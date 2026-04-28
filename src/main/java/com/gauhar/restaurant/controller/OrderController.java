package com.gauhar.restaurant.controller;

import com.gauhar.restaurant.dao.MenuItemDao;
import com.gauhar.restaurant.dao.OrderDao;
import com.gauhar.restaurant.dao.RestaurantDao;
import com.gauhar.restaurant.model.MenuItem;
import com.gauhar.restaurant.model.Order;
import com.gauhar.restaurant.model.OrderStatus;
import com.gauhar.restaurant.model.Cart;
import com.gauhar.restaurant.model.CartItem;
import com.gauhar.restaurant.model.OrderItem;
import com.gauhar.restaurant.repository.UserRepository;
import com.gauhar.restaurant.service.EmailService;
import com.gauhar.restaurant.service.OrderService;
import com.gauhar.restaurant.entity.Pizza;
import com.gauhar.restaurant.entity.Burger;
import com.gauhar.restaurant.entity.Drink;
import com.gauhar.restaurant.entity.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/orders")
public class OrderController {

    private final OrderDao orderDao;
    private final MenuItemDao menuItemDao;
    private final UserRepository userRepo;
    private final EmailService emailService;
    private final RestaurantDao restaurantDao;

    @Autowired
    private OrderService orderService;

    public OrderController(OrderDao orderDao,
                           MenuItemDao menuItemDao,
                           UserRepository userRepo,
                           EmailService emailService,
                           RestaurantDao restaurantDao) {
        this.orderDao = orderDao;
        this.menuItemDao = menuItemDao;
        this.userRepo = userRepo;
        this.emailService = emailService;
        this.restaurantDao = restaurantDao;
    }

    @GetMapping
    public String list(Model model, Authentication auth) {
        List<Order> orders = orderDao.findAll();
        model.addAttribute("orders", orders);

        String role = getRole(auth);
        model.addAttribute("role", role);
        model.addAttribute("isAdmin", "ADMIN".equals(role));

        List<MenuItem> menuItems = menuItemDao.findAll()
                .stream().filter(MenuItem::isAvailable).toList();
        model.addAttribute("menuItems", menuItems);

        try {
            com.gauhar.restaurant.model.Restaurant restaurant = restaurantDao.getOrCreateDefault();
            model.addAttribute("restaurant", restaurant);
        } catch (Exception e) {
            model.addAttribute("restaurant", new com.gauhar.restaurant.model.Restaurant());
        }

        return "orders"; // ✅ JSP view name
    }
    @GetMapping("/new")
    public String newOrderForm() {
        // Перенаправляем на основной список заказов, так как форма теперь там
        return "redirect:/orders";
    }

    @PostMapping("/new")
    public String createOrder(@RequestParam String customerName,
                              @RequestParam(required = false) String phone,
                              @RequestParam int menuItemId,
                              @RequestParam(defaultValue = "1") int qty,
                              @RequestParam(required = false) List<String> toppings,
                              Authentication auth,
                              RedirectAttributes flash) {
        try {
            User user = getUser(auth);

            // Получаем блюдо, чтобы узнать категорию
            MenuItem mi = menuItemDao.findById(menuItemId).orElse(null);
            String category = (mi != null) ? mi.getCategory().toLowerCase() : "";

            String toppingsText = "";
            if (toppings != null && !toppings.isEmpty()) {
                if (category.contains("pizza") || category.contains("пицц")) {
                    Pizza.Builder builder = new Pizza.Builder("Medium", "Thin");
                    if (toppings.contains("Сыр")) builder.cheese(true);
                    if (toppings.contains("Пепперони")) builder.pepperoni(true);
                    if (toppings.contains("Грибы")) builder.mushrooms(true);
                    if (toppings.contains("Оливки")) builder.olives(true);
                    toppingsText = builder.build().toString();
                } else if (category.contains("burger") || category.contains("бург")) {
                    Burger.Builder builder = new Burger.Builder();
                    if (toppings.contains("Лук")) builder.onion(true);
                    if (toppings.contains("Котлета")) builder.extraPatty(true);
                    if (toppings.contains("Сыр")) builder.cheese(true);
                    toppingsText = builder.build().toString();
                } else if (category.contains("drink") || category.contains("напит")) {
                    Drink.Builder builder = new Drink.Builder();
                    if (toppings.contains("Со льдом")) builder.ice(true);
                    if (toppings.contains("Лимон")) builder.lemon(true);
                    if (toppings.contains("Мята")) builder.mint(true);
                    toppingsText = builder.build().toString();
                } else {
                    toppingsText = String.join(", ", toppings);
                }
            }

            Order created = orderDao.createOrder(
                    user != null ? user.getId() : null,
                    user != null ? user.getEmail() : null,
                    customerName,
                    phone == null ? "" : phone,
                    menuItemId,
                    qty,
                    toppingsText
            );

            if (user != null && user.getEmail() != null && !user.getEmail().isBlank()) {
                try {
                    emailService.sendOrderAcceptedEmail(user.getEmail(), user.getFullName(), created.getId());
                } catch (Exception ignored) {
                }
            }

            flash.addFlashAttribute("successMsg",
                    "Заказ #" + created.getId() + " успешно создан!");

        } catch (Exception e) {
            flash.addFlashAttribute("errorMsg", "Ошибка: " + e.getMessage());
            return "redirect:/orders/new?itemId=" + menuItemId;
        }
        return "redirect:/orders";
    }

    @PostMapping("/{id}/status")
    public String updateStatus(@PathVariable int id,
                               @RequestParam String status,
                               RedirectAttributes flash) {
        try {
            OrderStatus newStatus = OrderStatus.valueOf(status.toUpperCase());
            orderDao.updateStatus(id, newStatus);

            Order order = orderDao.findById(id);

            if (order != null && order.getCustomerEmail() != null && !order.getCustomerEmail().isBlank()) {
                String customerName = order.getCustomerName() != null ? order.getCustomerName() : "Клиент";

                try {
                    switch (newStatus) {
                        case CONFIRMED -> emailService.sendOrderAcceptedEmail(order.getCustomerEmail(), customerName, id);
                        case PREPARING -> emailService.sendOrderPreparingEmail(order.getCustomerEmail(), customerName, id);
                        case READY -> emailService.sendOrderReadyEmail(order.getCustomerEmail(), customerName, id);
                        case DONE -> emailService.sendOrderDoneEmail(order.getCustomerEmail(), customerName, id);
                    }
                } catch (Exception ignored) {
                }
            }

            flash.addFlashAttribute("successMsg", "Статус заказа #" + id + " обновлён.");
        } catch (Exception e) {
            flash.addFlashAttribute("errorMsg", "Ошибка смены статуса: " + e.getMessage());
        }
        return "redirect:/orders";
    }

    @PostMapping("/create")
    public String createOrderFromCart(@RequestParam String customerName,
                                      @RequestParam(required = false) String phone,
                                      Authentication auth,
                                      HttpSession session,
                                      RedirectAttributes flash) {
        try {
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                flash.addFlashAttribute("errorMsg", "Корзина пуста!");
                return "redirect:/cart";
            }

            User user = getUser(auth);

            Order order = new Order();
            order.setCustomerName(customerName);
            order.setPhone(phone != null ? phone : "");
            order.setUserId(user != null ? user.getId() : null);
            order.setCustomerEmail(user != null ? user.getEmail() : null);

            List<OrderItem> orderItems = new ArrayList<>();
            for (CartItem cartItem : cart.getItems()) {
                MenuItem menuItem = menuItemDao.findById(Math.toIntExact(cartItem.getMenuItemId())).orElse(null);
                if (menuItem != null) {
                    OrderItem orderItem = new OrderItem(menuItem, cartItem.getQuantity(), cartItem.getOptions());
                    orderItems.add(orderItem);
                }
            }
            order.setItems(orderItems);

            // Сохраняем заказ в БД
            Order created = orderDao.createOrder(order);

            // Очищаем корзину
            session.removeAttribute("cart");

            if (user != null && user.getEmail() != null && !user.getEmail().isBlank()) {
                try {
                    emailService.sendOrderAcceptedEmail(user.getEmail(), user.getFullName(), created.getId());
                } catch (Exception ignored) {}
            }

            flash.addFlashAttribute("successMsg", "Заказ #" + created.getId() + " успешно создан!");
            return "redirect:/order-success";

        } catch (Exception e) {
            flash.addFlashAttribute("errorMsg", "Ошибка: " + e.getMessage());
            return "redirect:/cart";
        }
    }



    private User getUser(Authentication auth) {
        if (auth == null || auth.getPrincipal() == null) return null;
        Object principal = auth.getPrincipal();
        if (principal instanceof org.springframework.security.core.userdetails.User springUser) {
            return userRepo.findByEmail(springUser.getUsername()).orElse(null);
        }
        return null;
    }

    private String getRole(Authentication auth) {
        if (auth == null) return "CLIENT";
        for (GrantedAuthority a : auth.getAuthorities()) {
            String authority = a.getAuthority();
            if (authority != null && authority.startsWith("ROLE_")) {
                return authority.substring(5);
            }
        }
        return "CLIENT";
    }


    @PostMapping("/checkout")
    public String checkout(@RequestParam String name, @RequestParam String phone, @RequestParam String email, HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) return "redirect:/menu-items";

        com.gauhar.restaurant.model.Order order = new com.gauhar.restaurant.model.Order();
        order.setCustomerName(name);
        order.setPhone(phone);
        order.setCustomerEmail(email);
        order.setStatus(OrderStatus.PENDING);

        for (CartItem ci : cart.getItems()) {
            MenuItem mi = menuItemDao.findById(ci.getMenuItemId().intValue()).orElse(null);
            if (mi != null) {
                order.getItems().add(new OrderItem(mi, ci.getQuantity(), ci.getOptions()));
            }
        }

        orderDao.createOrder(order);
        cart.clear();
        return "redirect:/order-success";    }
}

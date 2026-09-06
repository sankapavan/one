import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

// Sweet class representing individual sweet items
class Sweet {
    private int id;
    private String name;
    private double price;
    private int quantity;
    
    public Sweet(int id, String name, double price) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.quantity = 0;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    @Override
    public String toString() {
        return id + ". " + name + " - ₹" + price + " (Available: " + quantity + ")";
    }
}

// Order class to manage customer orders
class Order {
    private List<Sweet> items;
    private double totalAmount;
    private String customerName;
    private String customerPhone;
    
    public Order(String customerName, String customerPhone) {
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.items = new ArrayList<>();
        this.totalAmount = 0.0;
    }
    
    public void addItem(Sweet sweet, int quantity) {
        Sweet orderItem = new Sweet(sweet.getId(), sweet.getName(), sweet.getPrice());
        orderItem.setQuantity(quantity);
        items.add(orderItem);
        totalAmount += sweet.getPrice() * quantity;
    }
    
    public void displayOrder() {
        System.out.println("\n========== ORDER SUMMARY ==========");
        System.out.println("Customer: " + customerName);
        System.out.println("Phone: " + customerPhone);
        System.out.println("------------------------------------");
        for (Sweet item : items) {
            System.out.println(item.getName() + " x" + item.getQuantity() + 
                             " = ₹" + (item.getPrice() * item.getQuantity()));
        }
        System.out.println("------------------------------------");
        System.out.println("Total Amount: ₹" + totalAmount);
        System.out.println("====================================\n");
    }
    
    public double getTotalAmount() { return totalAmount; }
}

// Main SweetOrderingSystem class
public class SweetOrderingSystem {
    private static List<Sweet> sweets = new ArrayList<>();
    private static List<Order> orders = new ArrayList<>();
    private static Scanner scanner = new Scanner(System.in);
    
    public static void main(String[] args) {
        initializeSweets();
        
        System.out.println("=====================================");
        System.out.println("   WELCOME TO SWEET DELIGHT STORE   ");
        System.out.println("=====================================\n");
        
        while (true) {
            displayMainMenu();
            int choice = getChoice();
            
            switch (choice) {
                case 1:
                    placeOrder();
                    break;
                case 2:
                    viewMenu();
                    break;
                case 3:
                    viewOrders();
                    break;
                case 4:
                    System.out.println("\nThank you for visiting Sweet Delight Store!");
                    System.out.println("Have a sweet day! 🍬\n");
                    System.exit(0);
                    break;
                default:
                    System.out.println("\nInvalid choice! Please try again.\n");
            }
        }
    }
    
    private static void initializeSweets() {
        sweets.add(new Sweet(1, "Gulab Jamun", 120.00));
        sweets.add(new Sweet(2, "Rasgulla", 100.00));
        sweets.add(new Sweet(3, "Ladoo", 150.00));
        sweets.add(new Sweet(4, "Barfi", 180.00));
        sweets.add(new Sweet(5, "Jalebi", 80.00));
        sweets.add(new Sweet(6, "Kaju Katli", 250.00));
        
        // Initial available stock
        for (Sweet sweet : sweets) {
            sweet.setQuantity(50);
        }
    }
    
    private static void displayMainMenu() {
        System.out.println("========== MAIN MENU ==========");
        System.out.println("1. Place New Order");
        System.out.println("2. View Menu");
        System.out.println("3. View All Orders");
        System.out.println("4. Exit");
        System.out.println("===============================");
        System.out.print("Enter your choice: ");
    }
    
    private static int getChoice() {
        try {
            return Integer.parseInt(scanner.nextLine());
        } catch (NumberFormatException e) {
            return -1;
        }
    }
    
    private static void placeOrder() {
        System.out.println("\n===== PLACE NEW ORDER =====");
        
        System.out.print("Enter your name: ");
        String name = scanner.nextLine();
        
        System.out.print("Enter phone number: ");
        String phone = scanner.nextLine();
        
        Order order = new Order(name, phone);
        
        while (true) {
            System.out.println("\nAvailable Sweets:");
            displaySweets();
            
            System.out.print("Enter sweet ID to order (0 to finish): ");
            int id = getChoice();
            
            if (id == 0) break;
            
            Sweet selected = findSweetById(id);
            if (selected == null) {
                System.out.println("Invalid sweet ID! Please try again.");
                continue;
            }
            
            System.out.print("Enter quantity: ");
            int quantity = getChoice();
            
            if (quantity <= 0) {
                System.out.println("Quantity must be positive!");
                continue;
            }
            
            if (quantity > selected.getQuantity()) {
                System.out.println("Insufficient stock! Available: " + selected.getQuantity());
                continue;
            }
            
            order.addItem(selected, quantity);
            selected.setQuantity(selected.getQuantity() - quantity);
            System.out.println("Added " + quantity + " " + selected.getName() + "(s) to your order.");
            
            System.out.print("Add more items? (y/n): ");
            String more = scanner.nextLine();
            if (more.equalsIgnoreCase("n")) break;
        }
        
        if (order.getTotalAmount() > 0) {
            orders.add(order);
            System.out.println("\n✅ Order placed successfully!");
            order.displayOrder();
        } else {
            System.out.println("\nNo items ordered. Order cancelled.");
        }
    }
    
    private static void viewMenu() {
        System.out.println("\n===== SWEET MENU =====");
        displaySweets();
        System.out.println();
    }
    
    private static void displaySweets() {
        System.out.println("ID | Name | Price | Stock");
        System.out.println("--------------------------");
        for (Sweet sweet : sweets) {
            System.out.println(sweet);
        }
        System.out.println("--------------------------");
    }
    
    private static Sweet findSweetById(int id) {
        for (Sweet sweet : sweets) {
            if (sweet.getId() == id) {
                return sweet;
            }
        }
        return null;
    }
    
    private static void viewOrders() {
        if (orders.isEmpty()) {
            System.out.println("\nNo orders placed yet.\n");
            return;
        }
        
        System.out.println("\n===== ALL ORDERS =====");
        for (int i = 0; i < orders.size(); i++) {
            System.out.println("Order #" + (i + 1));
            orders.get(i).displayOrder();
        }
    }
}

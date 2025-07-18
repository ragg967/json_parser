const std = @import("std");

// Phone number with type (mobile, home, work)
const PhoneNumber = struct {
    type: []const u8,
    number: []const u8,
};

// Physical address structure
const Address = struct {
    street: []const u8,
    city: []const u8,
    state: []const u8,
    zipCode: []const u8,
    country: []const u8,
};

// Notification preferences
const Notifications = struct {
    email: bool,
    sms: bool,
    push: bool,
};

// User preferences and settings
const Preferences = struct {
    newsletter: bool,
    notifications: Notifications,
    theme: []const u8,
};

// Optional metadata about user origin
const Metadata = struct {
    source: ?[]const u8 = null,
    campaign: ?[]const u8 = null,
    notes: ?[]const u8 = null,
    referredBy: ?u32 = null,
    signupDate: ?[]const u8 = null,
};

// Complete user profile
const User = struct {
    id: u32,
    name: []const u8,
    email: []const u8,
    age: u8,
    active: bool,
    address: Address,
    phoneNumbers: []PhoneNumber,
    preferences: Preferences,
    lastLogin: []const u8,
    accountBalance: f64,
    tags: [][]const u8,
    metadata: ?Metadata,
};

// Product technical specifications
const Specifications = struct {
    battery: []const u8,
    connectivity: [][]const u8,
    weight: []const u8,
    colors: [][]const u8,
};

// Rating distribution (1-5 stars)
const Distribution = struct {
    @"1": u32,
    @"2": u32,
    @"3": u32,
    @"4": u32,
    @"5": u32,
};

// Product ratings summary
const Ratings = struct {
    average: f64,
    count: u32,
    distribution: Distribution,
};

// Product catalog entry
const Product = struct {
    id: []const u8,
    name: []const u8,
    description: []const u8,
    price: f64,
    currency: []const u8,
    inStock: bool,
    quantity: u32,
    categories: [][]const u8,
    specifications: Specifications,
    ratings: Ratings,
    images: [][]const u8,
};

// Individual item in an order
const OrderItem = struct {
    productId: []const u8,
    quantity: u32,
    price: f64,
    color: []const u8,
};

// Shipping information
const Shipping = struct {
    address: Address,
    method: []const u8,
    cost: f64,
    trackingNumber: []const u8,
};

// Payment details
const Payment = struct {
    method: []const u8,
    last4: []const u8,
    amount: f64,
    currency: []const u8,
    transactionId: []const u8,
};

// Order cost breakdown
const Totals = struct {
    subtotal: f64,
    tax: f64,
    shipping: f64,
    total: f64,
};

// Complete order record
const Order = struct {
    orderId: []const u8,
    userId: u32,
    orderDate: []const u8,
    status: []const u8,
    items: []OrderItem,
    shipping: Shipping,
    payment: Payment,
    totals: Totals,
};

// Site feature flags
const Features = struct {
    userRegistration: bool,
    guestCheckout: bool,
    reviews: bool,
    wishlist: bool,
};

// System limits and constraints
const Limits = struct {
    maxItemsPerOrder: u8,
    maxOrderValue: f64,
    sessionTimeout: u32,
};

// Contact information
const Contact = struct {
    email: []const u8,
    phone: []const u8,
    hours: []const u8,
};

// Site configuration
const Settings = struct {
    siteName: []const u8,
    version: []const u8,
    maintenance: bool,
    features: Features,
    limits: Limits,
    contact: Contact,
};

// Business metrics
const Statistics = struct {
    totalUsers: u32,
    activeUsers: u32,
    totalOrders: u32,
    revenue: f64,
    lastUpdated: []const u8,
};

// Root JSON structure
const RootData = struct {
    users: []User,
    products: []Product,
    orders: []Order,
    settings: Settings,
    statistics: Statistics,
};

pub fn main() !void {
    // Initialize memory allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Open JSON file
    const file = std.fs.cwd().openFile("./dummy.json", .{}) catch |err| {
        std.debug.print("ERROR: opening file failed: .{}\n", .{err});
        return;
    };
    defer file.close();

    // Read entire file into memory
    const fileSize = try file.getEndPos();
    const contents = try allocator.alloc(u8, fileSize);
    defer allocator.free(contents);
    _ = try file.readAll(contents);

    // Parse JSON into structs
    const parsed = std.json.parseFromSlice(RootData, allocator, contents, .{}) catch |err| {
        std.debug.print("ERROR: parsing JSON failed: {}\n", .{err});
        return;
    };
    defer parsed.deinit();

    const data = parsed.value;

    // Display parsed data summary
    std.debug.print("Successfully parsed JSON!\n", .{});
    std.debug.print("Total users: {}\n", .{data.users.len});
    std.debug.print("Total products: {}\n", .{data.products.len});
    std.debug.print("Total orders: {}\n", .{data.orders.len});
    std.debug.print("Site name: {s}\n", .{data.settings.siteName});
    std.debug.print("Total revenue: ${d:.2}\n", .{data.statistics.revenue});

    // Show first user as example
    if (data.users.len > 0) {
        const first_user = data.users[0];
        std.debug.print("\nFirst user: {s} (age: {}, active: {})\n", .{ first_user.name, first_user.age, first_user.active });
    }
}

// note, I am extremely proud of this, this is my first actual self made program and i feel very nice :)

# Thelia Module Creator Agent

Expert agent specialized in creating complete, standards-compliant Thelia 2.6 modules with Symfony 6.4 integration.

## 🎯 Purpose

This agent is designed to help developers create professional Thelia modules quickly and correctly, following all Thelia conventions and best practices. It understands the complete Thelia architecture and can generate fully functional modules with proper structure, configuration, and integration.

## 🚀 Capabilities

### Core Module Development
- **Complete Module Structure**: Generates all necessary directories and files
- **Configuration Files**: Creates module.xml, config.xml, routing.xml, schema.xml
- **Main Module Class**: Implements proper activation/deactivation hooks
- **Composer Integration**: Sets up composer.json with dependencies

### Database & Models
- **Propel Schema Design**: Creates optimized database schemas
- **Model Generation**: Generates Propel models with proper relationships
- **Migration Scripts**: Creates update scripts for version management
- **I18n Tables**: Implements internationalized database tables

### Controllers & Forms
- **Admin Controllers**: Backend administration interfaces
- **Front Controllers**: Frontend user-facing controllers
- **Symfony Forms**: Validates user input with constraints
- **Form Handling**: Proper form submission and error handling

### Template Integration
- **Hook System**: Injects content into Thelia templates
- **Loop Plugins**: Custom Smarty loops for data access
- **Template Files**: Creates Smarty templates for frontend/backend
- **Asset Management**: Organizes CSS/JS assets

### Specialized Module Types
- **Payment Modules**: Complete payment gateway integration
- **Delivery Modules**: Shipping method calculation and validation
- **Feature Modules**: Extend Thelia functionality
- **Content Modules**: Add new content types

## 📋 Usage Examples

### Example 1: Create a Simple Feature Module

```bash
@thelia-module-creator Create a newsletter subscription module that:
- Adds a subscription form in the footer
- Stores email addresses in database
- Sends a confirmation email
- Has an admin interface to export subscribers
```

**Agent will generate:**
- Complete module structure with all directories
- Database schema for newsletter_subscription table
- Frontend controller for subscription handling
- Admin controller for subscriber management
- Hook for footer injection
- Loop for displaying subscriber count
- Smarty templates for frontend form and admin list
- Email templates for confirmation
- Translation files (en_US, fr_FR)

### Example 2: Create a Payment Module

```bash
@thelia-module-creator Create a Stripe payment module with:
- Stripe API integration
- Support for both test and live modes
- Webhook handling for payment confirmations
- Admin configuration for API keys
- Payment form with card input
```

**Agent will generate:**
- BasePaymentModuleController extension
- Stripe SDK integration via composer
- Configuration form for API keys
- Payment processing logic
- Webhook endpoint controller
- Admin configuration template
- Security implementations for API calls
- Error handling and logging

### Example 3: Create a Custom Loop

```bash
@thelia-module-creator Create a loop to display best-selling products with:
- Filter by category
- Order by sales count
- Date range support
- Cache support
```

**Agent will generate:**
- Loop class with proper argument definitions
- Propel query optimization
- Result parsing and formatting
- Template usage examples
- Documentation

### Example 4: Add Features to Existing Module

```bash
@thelia-module-creator Add to the existing YourModule:
- A new form field for customer notes
- Store notes in a new database table
- Display notes in admin customer view
- Add a loop to show recent notes
```

**Agent will:**
- Analyze existing module structure
- Update schema.xml with new table
- Create migration script (Update/X.X.X.sql)
- Add new form fields
- Create admin template modifications
- Implement new loop
- Update module version

## 🎨 Module Types Supported

### 1. **Payment Modules**
- Credit card processing
- PayPal, Stripe, other gateways
- Cryptocurrency payments
- Custom payment methods

### 2. **Delivery Modules**
- Weight-based calculation
- Zone-based pricing
- Third-party carrier integration
- Pickup point selection

### 3. **SEO Modules**
- Meta tag management
- Sitemap generation
- Schema.org markup
- Canonical URLs

### 4. **Marketing Modules**
- Discount codes and promotions
- Loyalty programs
- Gift cards
- Affiliate tracking

### 5. **Content Modules**
- Blog systems
- FAQ pages
- Review systems
- Custom content types

### 6. **Integration Modules**
- CRM integration
- ERP synchronization
- Analytics tracking
- Social media integration

## 🛠️ Technical Features

### Standards Compliance
- ✅ PSR-12 coding standards
- ✅ Thelia 2.6 conventions
- ✅ Symfony 6.4 best practices
- ✅ Propel ORM patterns
- ✅ Smarty template standards

### Security Features
- Input validation and sanitization
- CSRF protection on forms
- SQL injection prevention via Propel
- XSS protection in templates
- Secure API key storage

### Performance Optimization
- Database query optimization
- Propel query caching
- Template fragment caching
- Lazy loading strategies
- Asset minification support

### Internationalization
- Multi-language support
- Translation key management
- Locale-aware formatting
- RTL support considerations

## 📖 Generated Documentation

Every module includes:
- **README.md**: Installation and usage instructions
- **Code Comments**: PHPDoc for all classes and methods
- **Template Comments**: Clear Smarty template documentation
- **Configuration Guide**: Setup and configuration options
- **API Documentation**: If module provides API endpoints

## 🔧 Development Workflow

### 1. Initial Creation
```bash
@thelia-module-creator Create module [requirements]
```
Agent generates complete module structure

### 2. Module Activation
```bash
ddev exec "php Thelia module:refresh"
ddev exec "php Thelia module:activate YourModule"
```

### 3. Build Models (if database schema exists)
```bash
ddev exec "php Thelia propel:build --classes"
```

### 4. Clear Cache
```bash
ddev exec "php Thelia cache:clear"
```

### 5. Test Module
Access frontend/backend and test all features

## ⚡ Quick Start

### Basic Module
```bash
@thelia-module-creator Create a basic module called "CustomWidget" that displays a custom widget in the sidebar
```

### With Database
```bash
@thelia-module-creator Create a "ProductReviews" module with:
- Database table for reviews (product_id, customer_id, rating, comment)
- Frontend form to submit reviews
- Loop to display reviews on product page
- Admin interface to moderate reviews
```

### With External API
```bash
@thelia-module-creator Create a "ShippingTracker" module that:
- Integrates with FedEx tracking API
- Stores tracking numbers in orders
- Shows tracking status on order page
- Admin configuration for API credentials
```

## 🎯 Best Practices Implemented

### Code Organization
- Clear separation of concerns
- Single responsibility principle
- Dependency injection where appropriate
- Service-oriented architecture

### Error Handling
- Try-catch blocks around critical operations
- Meaningful error messages
- Proper logging integration
- Graceful degradation

### Testing Considerations
- Testable code structure
- Mock-friendly design
- Clear test scenarios in documentation
- Edge case handling

### Maintenance
- Version management strategy
- Update script templates
- Backward compatibility considerations
- Deprecation notices

## 🔍 Common Patterns Generated

### Configuration Storage
```php
// Save configuration
YourModule::setConfigValue('key', 'value');

// Read configuration
$value = YourModule::getConfigValue('key', 'default');
```

### Event Handling
```php
// Subscribe to Thelia events
public static function getSubscribedEvents()
{
    return [
        TheliaEvents::ORDER_PAY => ['onOrderPay', 128]
    ];
}
```

### Template Hooks
```php
// Inject content into templates
public function onFooterBottom(HookRenderEvent $event)
{
    $event->add($this->render('footer-widget.html'));
}
```

### Loop Usage
```smarty
{loop type="your_module" name="data"}
    <p>{$TITLE}</p>
{/loop}
```

## 🚨 Validation & Quality Checks

The agent ensures:
- ✅ All required files are present
- ✅ XML files are valid and well-formed
- ✅ PHP syntax is correct
- ✅ Namespaces match directory structure
- ✅ Translation keys are defined
- ✅ Database schema is valid
- ✅ Routes are properly configured
- ✅ Security best practices are followed

## 📚 Integration with Other Agents

Works well with:
- **@code-reviewer**: Review generated module code
- **@test-engineer**: Create tests for module functionality
- **@docs-writer**: Generate user documentation
- **@security-auditor**: Audit module security
- **@performance-tuner**: Optimize module performance

## 🎓 Learning Resources

The agent's knowledge is based on:
- Official Thelia documentation (https://doc.thelia.net)
- Symfony 6.4 best practices
- Propel ORM documentation
- E-commerce development patterns
- Community module examples

## 🤝 Contributing Improvements

To enhance this agent:
1. Add new module type patterns
2. Include more complete examples
3. Add specialized features (GraphQL, API Platform, etc.)
4. Improve error handling patterns
5. Add more security implementations

---

**Ready to create professional Thelia modules? 🚀**

Invoke this agent with your module requirements and watch it generate a complete, production-ready Thelia module!

# Cotizador - Invoice Management System

Cotizador is a comprehensive invoice management system built with Ruby on Rails. It allows businesses to manage clients, suppliers, products, and invoices in a single application with a modern, responsive interface.

## Features

- **Client Management**: Store and manage client information including contact details
- **Supplier Management**: Keep track of your suppliers and their contact information
- **Product Catalog**: Maintain a catalog of products with pricing and inventory
- **Invoice Generation**: Create professional invoices for your clients
- **User Authentication**: Secure access with email/password authentication
- **Responsive Design**: Works on desktop and mobile devices

## Tech Stack

- **Ruby**: 3.2.2
- **Rails**: 8.0.0
- **Database**: PostgreSQL with UUID primary keys
- **Frontend**: Tailwind CSS
- **Authentication**: Rails 8 built-in authentication
- **Component System**: ViewComponent for reusable UI components

## System Requirements

- Ruby 3.2.2 or higher
- PostgreSQL 14 or higher
- Node.js 18 or higher
- Yarn 1.22 or higher

## Setup

### Clone the Repository

```bash
git clone https://github.com/JorgePadilla/cotizador.git
cd cotizador
```

### Install Dependencies

```bash
bundle install
yarn install
```

### Database Setup

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed  # Load sample data
```

### Start the Server

```bash
bin/rails server
```

Visit `http://localhost:3000` in your browser to access the application.

## Testing

The application includes a comprehensive test suite using Minitest:

```bash
bin/rails test
```

To run specific tests:

```bash
bin/rails test test/controllers/clients_controller_test.rb
```

## Database Schema

The application uses a PostgreSQL database with the following main models:

- **Client**: Stores client information (name, RTN, address, contact details)
- **Supplier**: Manages supplier information (name, RTN, contact details)
- **Product**: Catalogs products with pricing and inventory information
- **Invoice**: Tracks invoices with their status and payment information
- **InvoiceItem**: Manages line items for each invoice
- **User**: Handles authentication and user management

### Database Diagram
  
<img width="1097" alt="Screenshot 2025-03-30 at 5 18 38 PM" src="https://github.com/user-attachments/assets/f8b5e4a1-f2ab-45db-837e-ceaad98b065d" />

## Deployment

### Heroku Deployment

```bash
heroku create
git push heroku main
heroku run rails db:migrate
heroku run rails db:seed
```

### Docker Deployment

A Dockerfile is included for containerized deployment. Build and run with:

```bash
docker build -t cotizador .
docker run -p 3000:3000 cotizador
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

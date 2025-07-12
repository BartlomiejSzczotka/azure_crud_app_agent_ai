# Azure CRUD Application

A simple CRUD (Create, Read, Update, Delete) application built with React frontend and Node.js backend, designed to work with Azure services.

## Features

- ✅ Product management (Create, Read, Update, Delete)
- ✅ Modern React frontend with responsive design
- ✅ RESTful API backend with Express.js
- ✅ In-memory data storage (easily replaceable with Azure SQL Database)
- ✅ Form validation and error handling
- ✅ Professional UI with Azure design theme

## Tech Stack

### Frontend
- React 18
- Axios for API calls
- Modern CSS with responsive design
- Azure-inspired color scheme

### Backend
- Node.js
- Express.js
- UUID for unique IDs
- CORS enabled
- JSON data storage (ready for Azure SQL integration)

## Project Structure

```
azure_crud_app_agent_ai/
├── backend/
│   ├── src/
│   │   └── server.js          # Express server with CRUD APIs
│   └── package.json           # Backend dependencies
├── frontend/
│   ├── src/
│   │   ├── App.js            # Main React component
│   │   ├── index.js          # React entry point
│   │   └── index.css         # Styles
│   ├── public/
│   │   └── index.html        # HTML template
│   └── package.json          # Frontend dependencies
└── README.md
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/products` | Get all products |
| GET | `/api/products/:id` | Get single product |
| POST | `/api/products` | Create new product |
| PUT | `/api/products/:id` | Update existing product |
| DELETE | `/api/products/:id` | Delete product |
| GET | `/api/health` | Health check |

## Getting Started

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/BartlomiejSzczotka/azure_crud_app_agent_ai.git
   cd azure_crud_app_agent_ai
   ```

2. **Install backend dependencies**
   ```bash
   cd backend
   npm install
   ```

3. **Install frontend dependencies**
   ```bash
   cd ../frontend
   npm install
   ```

### Running the Application

1. **Start the backend server** (from the backend directory):
   ```bash
   npm run dev
   ```
   Server will run on http://localhost:3001

2. **Start the frontend** (from the frontend directory):
   ```bash
   npm start
   ```
   App will open in browser at http://localhost:3000

## Usage

1. **Add Products**: Use the form to create new products with name, description, price, and category
2. **View Products**: All products are displayed in a responsive grid layout
3. **Edit Products**: Click the "Edit" button on any product card to modify it
4. **Delete Products**: Click the "Delete" button to remove a product (with confirmation)

## Azure Integration Ready

This application is structured to easily integrate with Azure services:

- **Azure App Service**: Deploy both frontend and backend
- **Azure SQL Database**: Replace in-memory storage with persistent database
- **Azure Cosmos DB**: Alternative NoSQL database option
- **Azure Storage**: For file uploads and static assets
- **Azure Functions**: For serverless API endpoints

## Sample API Response

```json
{
  "success": true,
  "data": [
    {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "name": "Sample Product",
      "description": "This is a sample product",
      "price": 29.99,
      "category": "Electronics",
      "createdAt": "2025-07-12T13:06:28.000Z"
    }
  ],
  "count": 1
}
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Next Steps

- [ ] Integrate Azure SQL Database
- [ ] Add user authentication
- [ ] Implement file upload functionality
- [ ] Add search and filtering
- [ ] Deploy to Azure App Service
- [ ] Add unit tests
- [ ] Implement caching with Azure Redis
Azure CRUD application built with AI agent assistance

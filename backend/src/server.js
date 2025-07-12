const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// In-memory data store (replace with Azure SQL Database later)
let products = [
  {
    id: uuidv4(),
    name: 'Sample Product 1',
    description: 'This is a sample product',
    price: 29.99,
    category: 'Electronics',
    createdAt: new Date().toISOString()
  },
  {
    id: uuidv4(),
    name: 'Sample Product 2',
    description: 'Another sample product',
    price: 49.99,
    category: 'Books',
    createdAt: new Date().toISOString()
  }
];

// Routes

// GET all products
app.get('/api/products', (req, res) => {
  res.json({
    success: true,
    data: products,
    count: products.length
  });
});

// GET single product
app.get('/api/products/:id', (req, res) => {
  const product = products.find(p => p.id === req.params.id);
  
  if (!product) {
    return res.status(404).json({
      success: false,
      message: 'Product not found'
    });
  }
  
  res.json({
    success: true,
    data: product
  });
});

// POST create product
app.post('/api/products', (req, res) => {
  const { name, description, price, category } = req.body;
  
  // Basic validation
  if (!name || !price) {
    return res.status(400).json({
      success: false,
      message: 'Name and price are required'
    });
  }
  
  const newProduct = {
    id: uuidv4(),
    name,
    description: description || '',
    price: parseFloat(price),
    category: category || 'Uncategorized',
    createdAt: new Date().toISOString()
  };
  
  products.push(newProduct);
  
  res.status(201).json({
    success: true,
    data: newProduct,
    message: 'Product created successfully'
  });
});

// PUT update product
app.put('/api/products/:id', (req, res) => {
  const productIndex = products.findIndex(p => p.id === req.params.id);
  
  if (productIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Product not found'
    });
  }
  
  const { name, description, price, category } = req.body;
  
  // Update product
  const updatedProduct = {
    ...products[productIndex],
    name: name || products[productIndex].name,
    description: description !== undefined ? description : products[productIndex].description,
    price: price !== undefined ? parseFloat(price) : products[productIndex].price,
    category: category || products[productIndex].category,
    updatedAt: new Date().toISOString()
  };
  
  products[productIndex] = updatedProduct;
  
  res.json({
    success: true,
    data: updatedProduct,
    message: 'Product updated successfully'
  });
});

// DELETE product
app.delete('/api/products/:id', (req, res) => {
  const productIndex = products.findIndex(p => p.id === req.params.id);
  
  if (productIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Product not found'
    });
  }
  
  const deletedProduct = products.splice(productIndex, 1)[0];
  
  res.json({
    success: true,
    data: deletedProduct,
    message: 'Product deleted successfully'
  });
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'Server is running',
    timestamp: new Date().toISOString()
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'Something went wrong!'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/api/health`);
  console.log(`API endpoint: http://localhost:${PORT}/api/products`);
});

module.exports = app;

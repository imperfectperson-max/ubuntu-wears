require('dotenv').config();
const mongoose = require('mongoose');
const Product = require('./models/Products'); // make sure path matches your model

// Sample product data
const products = [
  {
    name: 'Zulu Beaded Necklace',
    description: 'Handmade traditional Zulu beaded necklace',
    category: 'Accessories',
    price: 250,
    stock: 10,
    images: [
      'https://example.com/images/zulu-necklace1.jpg',
      'https://example.com/images/zulu-necklace2.jpg'
    ]
  },
  {
    name: 'Shweshwe Dress',
    description: 'Authentic South African Shweshwe fabric dress',
    category: 'Clothing',
    price: 550,
    stock: 15,
    images: [
      'https://example.com/images/shweshwe-dress1.jpg',
      'https://example.com/images/shweshwe-dress2.jpg'
    ]
  },
  {
    name: 'Ndebele Beaded Earrings',
    description: 'Colorful Ndebele-inspired earrings',
    category: 'Accessories',
    price: 150,
    stock: 20,
    images: [
      'https://example.com/images/ndebele-earrings1.jpg',
      'https://example.com/images/ndebele-earrings2.jpg'
    ]
  }
];

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    console.log('MongoDB Connected');
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

const importData = async () => {
  try {
    await Product.deleteMany(); // clear existing products
    await Product.insertMany(products);
    console.log('Products Imported!');
    process.exit();
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

connectDB().then(importData);

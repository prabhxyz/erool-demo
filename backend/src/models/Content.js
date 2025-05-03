const mongoose = require('mongoose');

const contentSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true,
    maxlength: 100
  },
  content: {
    type: String,
    required: true,
    trim: true,
    maxlength: 500 // Limiting to short-form content
  },
  topic: {
    type: String,
    required: true,
    enum: ['Math', 'Physics', 'Chemistry', 'Biology', 'Computer Science', 'Engineering']
  },
  difficulty: {
    type: String,
    enum: ['Beginner', 'Intermediate', 'Advanced'],
    default: 'Beginner'
  },
  author: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  likes: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  comments: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    text: {
      type: String,
      required: true,
      trim: true
    },
    createdAt: {
      type: Date,
      default: Date.now
    }
  }],
  tags: [{
    type: String,
    trim: true
  }],
  readingTime: {
    type: Number, // in seconds
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Index for better search performance
contentSchema.index({ topic: 1, createdAt: -1 });
contentSchema.index({ tags: 1 });

module.exports = mongoose.model('Content', contentSchema); 
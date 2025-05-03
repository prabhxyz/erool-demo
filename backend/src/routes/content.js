const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const Content = require('../models/Content');
const auth = require('../middleware/auth');

// Get feed content
router.get('/feed', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.userId);
    const topics = user.topics || [];

    // Get content based on user's topics and preferences
    const content = await Content.find({
      topic: { $in: topics }
    })
    .sort({ createdAt: -1 })
    .limit(20)
    .populate('author', 'username');

    res.json(content);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Create new content
router.post('/', [
  auth,
  body('title').trim().isLength({ min: 1, max: 100 }),
  body('content').trim().isLength({ min: 1, max: 500 }),
  body('topic').isIn(['Math', 'Physics', 'Chemistry', 'Biology', 'Computer Science', 'Engineering']),
  body('difficulty').optional().isIn(['Beginner', 'Intermediate', 'Advanced']),
  body('tags').optional().isArray(),
  body('readingTime').isInt({ min: 15, max: 60 })
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const content = new Content({
      ...req.body,
      author: req.user.userId
    });

    await content.save();
    res.status(201).json(content);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Like content
router.post('/:id/like', auth, async (req, res) => {
  try {
    const content = await Content.findById(req.params.id);
    if (!content) {
      return res.status(404).json({ message: 'Content not found' });
    }

    // Check if already liked
    if (content.likes.includes(req.user.userId)) {
      return res.status(400).json({ message: 'Content already liked' });
    }

    content.likes.push(req.user.userId);
    await content.save();

    res.json(content);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Add comment
router.post('/:id/comments', [
  auth,
  body('text').trim().isLength({ min: 1, max: 200 })
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const content = await Content.findById(req.params.id);
    if (!content) {
      return res.status(404).json({ message: 'Content not found' });
    }

    const comment = {
      user: req.user.userId,
      text: req.body.text
    };

    content.comments.push(comment);
    await content.save();

    res.json(content);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get content by topic
router.get('/topic/:topic', async (req, res) => {
  try {
    const content = await Content.find({ topic: req.params.topic })
      .sort({ createdAt: -1 })
      .populate('author', 'username');

    res.json(content);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router; 
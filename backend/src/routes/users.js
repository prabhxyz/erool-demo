const express = require('express');
const router = express.Router();
const User = require('../models/User');
const auth = require('../middleware/auth');

// Get user profile
router.get('/profile', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.userId)
      .select('-password')
      .populate('bookmarks');
    res.json(user);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Update user profile
router.put('/profile', auth, async (req, res) => {
  try {
    const { topics, username } = req.body;
    
    const user = await User.findById(req.user.userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    if (topics) user.topics = topics;
    if (username) user.username = username;

    await user.save();
    res.json(user);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get user's bookmarks
router.get('/bookmarks', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.userId)
      .populate('bookmarks');
    res.json(user.bookmarks);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Add bookmark
router.post('/bookmarks/:contentId', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    if (!user.bookmarks.includes(req.params.contentId)) {
      user.bookmarks.push(req.params.contentId);
      await user.save();
    }

    res.json(user.bookmarks);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Remove bookmark
router.delete('/bookmarks/:contentId', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    user.bookmarks = user.bookmarks.filter(
      bookmark => bookmark.toString() !== req.params.contentId
    );
    await user.save();

    res.json(user.bookmarks);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router; 
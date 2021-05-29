import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';

const NumberCards = [
  "इक्का",
  "दुक्की",
  "तिक्की",
  "चौक्की",
  "पंजी",
  "छक्की",
  "सत्ती",
  "अत्ठी",
  "नैल्ली",
  "दैल्ली",
  "गुलाम",
  "बेगम",
  "बादशाह"
];

const AllCards = [
  // Clubs
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "का इक्का"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "की दुक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "की तिक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "की चौक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "की पंजी"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "की छक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "की सत्ती"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "की अत्ठी"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "की नैल्ली"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "की दैल्ली"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "का गुलाम"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "की बेगम"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_club,
      color: Colors.black,
    ),
    "का बादशाह"
  ],

  // Diamonds
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "का इक्का"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "की दुक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "की तिक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "की चौक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "की पंजी"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "की छक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "की सत्ती"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "की अत्ठी"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "की नैल्ली"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "की दैल्ली"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "का गुलाम"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "की बेगम"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_diamond,
      color: Colors.red,
    ),
    "का बादशाह"
  ],

  // Hearts
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "का इक्का"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "की दुक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "की तिक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "की चौक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "की पंजी"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "की छक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "की सत्ती"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "की अत्ठी"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "की नैल्ली"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "की दैल्ली"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "का गुलाम"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "की बेगम"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_heart,
      color: Colors.red,
    ),
    "का बादशाह"
  ],

  // Spades
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "का इक्का"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "की दुक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "की तिक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "की चौक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "की पंजी"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "की छक्की"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "की सत्ती"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "की अत्ठी"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "की नैल्ली"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "की दैल्ली"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "का गुलाम"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "की बेगम"
  ],
  [
    Icon(
      MaterialCommunityIcons.cards_spade,
      color: Colors.black,
    ),
    "का बादशाह"
  ],
];

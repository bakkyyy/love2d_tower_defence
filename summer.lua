local Tile = require 'tile'

return {
    tiles = {
        {
            Tile:new("tile_treeQuad_E.png", {1,1}, {1,1}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeDouble_W.png", {2,1}, {2,1}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeDouble_S.png", {3,1}, {3,1}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeQuad_E.png", {4,1}, {4,1}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {5,1}, {5,1}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {6,1}, {6,1}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {7,1}, {7,1}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {8,1}, {8,1}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {9,1}, {9,1}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {10,1}, {10,1}, DRAW_MODE_1x1, true),
            Tile:new("tile_riverStraight_N.png", {11,1}, {11,1}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeDouble_W.png", {12,1}, {12,1}, DRAW_MODE_1x1, false)
        },
        {
            Tile:new("tile_treeDouble_W.png", {1,2}, {1,2}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeQuad_E.png", {2,2}, {2,2}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeQuad_E.png", {3,2}, {3,2}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeDouble_W.png", {4,2}, {4,2}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {5,2}, {5,2}, DRAW_MODE_1x1, true),
            Tile:new("tile_cornerSquare_S.png", {6,2}, {6,2}, DRAW_MODE_1x1, false),
            Tile:new("tile_straight_E.png", {7,2}, {7,2}, DRAW_MODE_1x1, false),
            Tile:new("tile_bump_E.png", {8,2}, {8,2}, DRAW_MODE_1x1, false),
            Tile:new("tile_straight_E.png", {9,2}, {9,2}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_W.png", {10,2}, {10,2}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_N.png", {11,2}, {11,2}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeQuad_E.png", {12,2}, {12,2}, DRAW_MODE_1x1, false)
        },
        {
            Tile:new("tile_treeDouble_S.png", {1,3}, {1,3}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeQuad_E.png", {2,3}, {2,3}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeQuad_E.png", {3,3}, {3,3}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {4,3}, {4,3}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {5,3}, {5,3}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {6,3}, {6,3}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {7,3}, {7,3}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {8,3}, {8,3}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {9,3}, {9,3}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {10,3}, {10,3}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_N.png", {11,3}, {11,3}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeDouble_W.png", {12,3}, {12,3}, DRAW_MODE_1x1, false)
        },
        {
            Tile:new("tile_treeQuad_E.png", {1,4}, {1,4}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeQuad_E.png", {2,4}, {2,4}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeDouble_W.png", {3,4}, {3,4}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {4,4}, {4,4}, DRAW_MODE_1x1, true),
            Tile:new("tile_cornerSquare_S.png", {5,4}, {5,4}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_N.png", {6,4}, {6,4}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {7,4}, {7,4}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {8,4}, {8,4}, DRAW_MODE_1x1, true),
            Tile:new("tile_cornerSquare_S.png", {9,4}, {9,4}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_N.png", {10,4}, {10,4}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_N.png", {11,4}, {11,4}, DRAW_MODE_1x1, false),
            Tile:new("tile_endSpawn_S.png", {12,4}, {12,4}, DRAW_MODE_1x1, false)
        },
        {
            Tile:new("tile_treeDouble_S.png", {1,5}, {1,5}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeDouble_S.png", {2,5}, {2,5}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeQuad_E.png", {3,5}, {3,5}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {4,5}, {4,5}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {5,5}, {5,5}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverCorner_S.png", {6,5}, {6,5}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_W.png", {7,5}, {7,5}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_W.png", {8,5}, {8,5}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverBridge_W.png", {9,5}, {9,5}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_W.png", {10,5}, {10,5}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverCorner_N.png", {11,5}, {11,5}, DRAW_MODE_1x1, false),
            Tile:new("tile_straight_N.png", {12,5}, {12,5}, DRAW_MODE_1x1, false)
        },
        {
            Tile:new("tile_treeQuad_E.png", {1,6}, {1,6}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverCorner_S.png", {2,6}, {2,6}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_W.png", {3,6}, {3,6}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverCorner_W.png", {4,6}, {4,6}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_E.png", {5,6}, {5,6}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverBridge_N.png", {6,6}, {6,6}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_W.png", {7,6}, {7,6}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {8,6}, {8,6}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {9,6}, {9,6}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {10,6}, {10,6}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {11,6}, {11,6}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {12,6}, {12,6}, DRAW_MODE_1x1, false)
        },
        {
            Tile:new("tile_treeDouble_W.png", {1,7}, {1,7}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_N.png", {2,7}, {2,7}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {3,7}, {3,7}, DRAW_MODE_1x1, true),
            Tile:new("tile_riverStraight_N.png", {4,7}, {4,7}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {5,7}, {5,7}, DRAW_MODE_1x1, true),
            Tile:new("tile_riverStraight_N.png", {6,7}, {6,7}, DRAW_MODE_1x1, false),
            Tile:new("tile_straight_N.png", {7,7}, {7,7}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {8,7}, {8,7}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {9,7}, {9,7}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {10,7}, {10,7}, DRAW_MODE_1x1, true),
            Tile:new("tile_cornerSquare_S.png", {11,7}, {11,7}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_N.png", {12,7}, {12,7}, DRAW_MODE_1x1, false)
        },
        {
            Tile:new("tile_treeQuad_E.png", {1,8}, {1,8}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_N.png", {2,8}, {2,8}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_S.png", {3,8}, {3,8}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverBridge_N.png", {4,8}, {4,8}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_W.png", {5,8}, {5,8}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_N.png", {6,8}, {6,8}, DRAW_MODE_1x1, false),
            Tile:new("tile_bump_N.png", {7,8}, {7,8}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {8,8}, {8,8}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {9,8}, {9,8}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {10,8}, {10,8}, DRAW_MODE_1x1, true),
            Tile:new("tile_bump_N.png", {11,8}, {11,8}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {12,8}, {12,8}, DRAW_MODE_1x1, true)
        },
        {
            Tile:new("tile_riverFall_E.png", {1,9}, {1,9}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverCorner_N.png", {2,9}, {2,9}, DRAW_MODE_1x1, false),
            Tile:new("tile_straight_N.png", {3,9}, {3,9}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_N.png", {4,9}, {4,9}, DRAW_MODE_1x1, false),
            Tile:new("tile_straight_N.png", {5,9}, {5,9}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_N.png", {6,9}, {6,9}, DRAW_MODE_1x1, false),
            Tile:new("tile_straight_N.png", {7,9}, {7,9}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {8,9}, {8,9}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {9,9}, {9,9}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {10,9}, {10,9}, DRAW_MODE_1x1, true),
            Tile:new("tile_cornerSquare_E.png", {11,9}, {11,9}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_W.png", {12,9}, {12,9}, DRAW_MODE_1x1, false)
        },
        {
            Tile:new("tile_N.png", {1,10}, {1,10}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {2,10}, {2,10}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {3,10}, {3,10}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_N.png", {4,10}, {4,10}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_E.png", {5,10}, {5,10}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverBridge_N.png", {6,10}, {6,10}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_N.png", {7,10}, {7,10}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {8,10}, {8,10}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {9,10}, {9,10}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {10,10}, {10,10}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {11,10}, {11,10}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {12,10}, {12,10}, DRAW_MODE_1x1, false)
        },
        {
            Tile:new("tile_endRoundSpawn_E.png", {1,11}, {1,11}, DRAW_MODE_1x1, false),
            Tile:new("tile_straight_E.png", {2,11}, {2,11}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_N.png", {3,11}, {3,11}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverCorner_E.png", {4,11}, {4,11}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverStraight_W.png", {5,11}, {5,11}, DRAW_MODE_1x1, false),
            Tile:new("tile_riverCorner_N.png", {6,11}, {6,11}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {7,11}, {7,11}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {8,11}, {8,11}, DRAW_MODE_1x1, true),
            Tile:new("tile_cornerSquare_E.png", {9,11}, {9,11}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_W.png", {10,11}, {10,11}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {11,11}, {11,11}, DRAW_MODE_1x1, true),
            Tile:new("tile_straight_N.png", {12,11}, {12,11}, DRAW_MODE_1x1, false)
        },
        {
            Tile:new("tile_N.png", {1,12}, {1,12}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {2,12}, {2,12}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {3,12}, {3,12}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {4,12}, {4,12}, DRAW_MODE_1x1, true),
            Tile:new("tile_treeQuad_E.png", {5,12}, {5,12}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeDouble_W.png", {6,12}, {6,12}, DRAW_MODE_1x1, false),
            Tile:new("tile_treeQuad_E.png", {7,12}, {7,12}, DRAW_MODE_1x1, false),
            Tile:new("tile_N.png", {8,12}, {8,12}, DRAW_MODE_1x1, true),
            Tile:new("tile_N.png", {9,12}, {9,12}, DRAW_MODE_1x1, true),
            Tile:new("tile_cornerSquare_E.png", {10,12}, {10,12}, DRAW_MODE_1x1, false),
            Tile:new("tile_straight_E.png", {11,12}, {11,12}, DRAW_MODE_1x1, false),
            Tile:new("tile_cornerSquare_N.png", {12,12}, {12,12}, DRAW_MODE_1x1, false)
        }
    },
    paths = {
        {{1,11},{3,11},{3,8},{5,8},{5,10},{7,10},{7,6},{5,6},{5,4},{6,4},{6,2},{10,2},{10,4},{9,4},{9,11},{10,11},{10,12},{12,12},{12,9},{11,9},{11,7},{12,7},{12,4}}
    },
    waves = {
        {
            {
                type = 1,
                count = 1,
                speed = 2,
                reward = 2,
                health = 6,
                spawnInterval = 2
            },
            {
                type = 1,
                count = 19,
                speed = 2,
                reward = 2,
                health = 6,
                spawnInterval = 1
            }
        },
        {
            {
                type = 2,
                count = 1,
                speed = 2,
                reward = 1,
                health = 6,
                spawnInterval = 4
            },
            {
                type = 2,
                count = 24,
                speed = 2,
                reward = 1,
                health = 6,
                spawnInterval = 0.5
            },
            {
                type = 3,
                count = 1,
                speed = 1.5,
                reward = 5,
                health = 36,
                spawnInterval = 5
            },
            {
                type = 3,
                count = 4,
                speed = 1.5,
                reward = 5,
                health = 36,
                spawnInterval = 2
            }
        },
        {
            {
                type = 1,
                count = 1,
                speed = 2,
                reward = 2,
                health = 15,
                spawnInterval = 5
            },
            {
                type = 1,
                count = 19,
                speed = 2,
                reward = 2,
                health = 15,
                spawnInterval = 0.75
            },
            {
                type = 4,
                count = 1,
                speed = 1.5,
                reward = 15,
                health = 95,
                spawnInterval = 10
            }
        },
        {
            {
                type = 2,
                count = 1,
                speed = 2.2,
                reward = 2,
                health = 6,
                spawnInterval = 8
            },
            {
                type = 2,
                count = 29,
                speed = 2.2,
                reward = 2,
                health = 6,
                spawnInterval = 0.4
            },
            {
                type = 3,
                count = 1,
                speed = 1.75,
                reward = 8,
                health = 50,
                spawnInterval = 7.5
            },
            {
                type = 3,
                count = 7,
                speed = 1.75,
                reward = 8,
                health = 50,
                spawnInterval = 1.5
            },
        },
        {
            {
                type = 1,
                count = 1,
                speed = 2,
                reward = 3,
                health = 25,
                spawnInterval = 7
            },
            {
                type = 1,
                count = 24,
                speed = 2,
                reward = 3,
                health = 25,
                spawnInterval = 0.8
            }
        },
        {
            {
                type = 2,
                count = 1,
                speed = 1.9,
                reward = 2,
                health = 10,
                spawnInterval = 8
            },
            {
                type = 2,
                count = 27,
                speed = 1.9,
                reward = 2,
                health = 10,
                spawnInterval = 0.35
            },
            {
                type = 3,
                count = 1,
                speed = 1.5,
                reward = 8,
                health = 67,
                spawnInterval = 6
            },
            {
                type = 3,
                count = 9,
                speed = 1.65,
                reward = 8,
                health = 67,
                spawnInterval = 1.5
            }
        },
        {
            {
                type = 1,
                count = 1,
                speed = 2.1,
                reward = 3,
                health = 40,
                spawnInterval = 7
            },
            {
                type = 1,
                count = 24,
                speed = 2.1,
                reward = 3,
                health = 40,
                spawnInterval = 0.9
            }
        },
        {
            {
                type = 4,
                count = 1,
                speed = 1.4,
                reward = 25,
                health = 150,
                spawnInterval = 7
            },
            {
                type = 4,
                count = 3,
                speed = 1.4,
                reward = 25,
                health = 150,
                spawnInterval = 2.5
            },
            {
                type = 2,
                count = 1,
                speed = 2.3,
                reward = 2,
                health = 14,
                spawnInterval = 6
            },
            {
                type = 2,
                count = 34,
                speed = 2.3,
                reward = 2,
                health = 14,
                spawnInterval = 0.3
            }
        },
        {
            {
                type = 1,
                count = 1,
                speed = 2.1,
                reward = 4,
                health = 50,
                spawnInterval = 6
            },
            {
                type = 1,
                count = 29,
                speed = 2.1,
                reward = 4,
                health = 50,
                spawnInterval = 0.5
            }
        },
        {
            {
                type = 4,
                count = 1,
                speed = 2,
                reward = 50,
                health = 450,
                spawnInterval = 10
            },
            {
                type = 4,
                count = 2,
                speed = 2,
                reward = 50,
                health = 450,
                spawnInterval = 4
            }
        }
    }
}

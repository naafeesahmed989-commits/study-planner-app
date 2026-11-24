
# My Study Planner

A Flutter mobile app that helps students plan their study time. You write down what you want to study and for how many hours, tick the goals you finish, and remove the ones you no longer need.

The app is built step by step in 5 phases:

- A static screen
- A working list
- Statistics
- A second screen with a form
- A database so goals are saved when the app closes

---

## Group 11

| No. | Registration Number |
|:---:|:---:|
| 1 | 25904/2024 |
| 2 | 26057/2024 |
| 3 | 26308/2024 |
| 4 | 26323/2024 |
| 5 | 27444/2024 |

---

## Progress

| Phase | What it adds | Status |
|:---:|---|:---:|
| 1 | Static screen with fixed goal cards | Done |
| 2 | Working list: add, tick and delete goals | Done |
| 3 | Statistics and cards | Not started |
| 4 | Second screen with a validated form | Not started |
| 5 | Database with sqflite | Not started |

---

## Design

An orange and pink palette (#F57E1E and #F52380) on a warm off-white background, with a gradient AppBar and banner and white rounded goal cards.

---

## Phase 1: Static Screen

Fixed content only:

- A gradient AppBar
- A welcome banner
- The heading "My Study Goals"
- Five goal cards
- An "Add goal" button that does nothing yet

### Screenshot

![Static Screen](screen_shoots/PHASE1)

---

## Phase 2: Working List

The goals are now stored in a list and every change updates the screen.

- The "Add goal" button adds a goal.
- Tapping a card ticks it as done.
- The bin icon removes it.

### Adding New Goals

![Adding New Goals](screen_shoots/PHASE2_adding_new_labels)

### Selecting and Removing Goals

![Selecting and Removing Goals](screen_shoots/PHASE2_selecting_and_removing_goals)

.
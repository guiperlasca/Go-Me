<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2017+-blue?style=for-the-badge&logo=apple&logoColor=white" />
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift&logoColor=white" />
  <img src="https://img.shields.io/badge/SwiftUI-Framework-blue?style=for-the-badge&logo=swift&logoColor=white" />
  <img src="https://img.shields.io/badge/Apple%20Academy-Project-black?style=for-the-badge&logo=apple&logoColor=white" />
</p>

<h1 align="center">
  🎯 GOMe
</h1>

<p align="center">
  <strong>Track goals. Save together.</strong>
</p>

<p align="center">
  A native iOS app for personal and group financial goal tracking,<br/>
  built with SwiftUI and designed with Apple's Human Interface Guidelines in mind.
</p>

<p align="center">
  <em>Originally developed at the <strong>Apple Developer Academy</strong></em>
</p>

---

## 📖 About

**GOMe** is a financial goal-tracking app that helps users set savings goals, link transactions to those goals, and track progress in real time — individually or with friends.

Whether you're saving for a new TV, a group trip, or a birthday gift, GOMe gives you clear metrics, visual progress rings, and the ability to invite friends to collaborate on shared goals.

The app was originally created as a project at the **Apple Developer Academy** and has since been enhanced with new features, a complete architectural overhaul, and a polished UI ready for the App Store.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔐 **Sign in with Apple** | Secure, native authentication using Apple ID |
| 🎯 **Personal Goals** | Set savings targets with deadlines and categories |
| 👥 **Group Goals** | Create shared goals and invite friends to save together |
| 💰 **Wallet Tracking** | Log expenses and income with category tagging |
| 🔗 **Goal Linking** | Link wallet transactions directly to goals for automatic progress calculation |
| 📊 **Metrics Dashboard** | View saved amount, remaining, daily savings needed, and progress percentage |
| 🧑‍🤝‍🧑 **Friends System** | Add friends, manage your social circle, and invite them to group goals |
| 👤 **Profile Customization** | Personalize your avatar, display name, and view personal stats |
| 🌙 **Dark Mode Design** | Fully dark-themed UI with glassmorphism and gradient accents |

---

## 📱 Screens

```
┌─────────────────────────────────────────────┐
│                  GOMe App                   │
├─────────────────────────────────────────────┤
│                                             │
│  🔐 Login Screen                            │
│   └─ Sign in with Apple                     │
│                                             │
│  🏠 Home (Tab 1)                            │
│   ├─ Balance card (income / expenses)       │
│   ├─ Quick stats (goals, completed, groups) │
│   ├─ Goals carousel                         │
│   └─ Recent transactions                    │
│                                             │
│  🎯 Goals (Tab 2)                           │
│   ├─ Personal / Group tab picker            │
│   ├─ Category filter                        │
│   ├─ Search                                 │
│   ├─ Group avatars scroller                 │
│   └─ Goal grid → Goal Detail                │
│       ├─ Progress ring                      │
│       ├─ Metrics dashboard                  │
│       ├─ Members section                    │
│       └─ Linked transactions                │
│                                             │
│  👤 Profile (Tab 3)                         │
│   ├─ Avatar & name editor                   │
│   ├─ Stats cards                            │
│   ├─ Friends list                           │
│   └─ Sign out                               │
│                                             │
└─────────────────────────────────────────────┘
```

---

## 🏗️ Architecture

```
GoMe/
├── GoMeApp.swift                 # App entry point (auth routing)
├── Info.plist
│
├── Models/
│   ├── Category.swift            # Expense/goal categories enum
│   ├── Goal.swift                # Goal model with computed progress
│   ├── Wallet.swift              # Transaction model with goal linking
│   ├── Friend.swift              # Friend model
│   └── UserProfile.swift         # User profile model
│
├── Services/
│   ├── AuthManager.swift         # Sign in with Apple + session management
│   └── GoalCalculator.swift      # Goal metrics & wallet linking utility
│
├── Screens/
│   ├── LoginScreen.swift         # Onboarding + Sign in with Apple
│   ├── MainTabView.swift         # Tab navigation (Home / Goals / Profile)
│   ├── Home.swift                # Dashboard with balance & overview
│   ├── GoalsScreen.swift         # Goals grid with filters
│   ├── GoalDetailScreen.swift    # Full goal detail with metrics
│   ├── AddGoal.swift             # Create new goal sheet
│   ├── AddWallet.swift           # Create transaction with goal linking
│   ├── WalletScreen.swift        # All transactions list
│   ├── AddMembersSheet.swift     # Friend selection for groups
│   └── ProfileScreen.swift       # User profile & friends
│
├── Components/
│   ├── GoalView.swift            # Goal card (compact & full variants)
│   └── WalletView.swift          # Transaction row component
│
└── Assets.xcassets/
    ├── AppIcon
    ├── PrimaryBlue.colorset
    ├── PrimaryGreen.colorset
    ├── blackBox.colorset
    └── DarkBackground.colorset
```

---

## 🔧 Tech Stack

- **Language:** Swift 5.9
- **UI Framework:** SwiftUI
- **Minimum Target:** iOS 17+
- **Authentication:** Sign in with Apple (`AuthenticationServices`)
- **State Management:** `@Observable` (Observation framework)
- **Design:** Apple Human Interface Guidelines, dark mode, glassmorphism

---

## 🚀 Getting Started

### Prerequisites

- Xcode 15+
- iOS 17+ Simulator or device
- Apple Developer account (for Sign in with Apple)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/guiperlasca/Go-Me.git
   cd Go-Me
   ```

2. **Open in Xcode**
   ```bash
   open GoMe.xcodeproj
   ```

3. **Configure Signing**
   - Select the project in Xcode
   - Go to **Signing & Capabilities**
   - Select your development team
   - Add **Sign in with Apple** capability

4. **Build & Run**
   - Select an iOS 17+ simulator or connected device
   - Press `Cmd + R`

---

## 🧠 How Goal Progress Works

The core feature of GOMe is **linking wallet transactions to goals** to calculate real progress:

```
1. User creates a goal        →  "TV 4K" with target $675
2. User adds a transaction     →  $200 freelance payment  
3. User links it to the goal   →  Select "TV 4K" in Goal Picker
4. GoalCalculator computes     →  $200 / $675 = 29.6% progress
5. UI updates automatically    →  Progress ring, bar, metrics
```

**Metrics calculated:**
- ✅ Amount saved vs. target
- 📊 Progress percentage  
- 📅 Days remaining
- 💵 Daily savings needed to reach the goal

---

## 👥 Team

<table>
  <tr>
    <td align="center">
      <strong>Guilherme Perlasca</strong><br/>
      <sub>Developer</sub><br/>
      <sub>Co-creator at Apple Developer Academy.<br/>Latest updates: Auth, Goal Linking, Profile,<br/>Group System, UI/UX Overhaul</sub><br/><br/>
      <a href="https://github.com/guiperlasca">
        <img src="https://img.shields.io/badge/GitHub-guiperlasca-181717?style=flat-square&logo=github" />
      </a>
    </td>
    <td align="center">
      <strong>Laura Klippel</strong><br/>
      <sub>Developer</sub><br/>
      <sub>Co-creator at Apple Developer Academy</sub>
    </td>
  </tr>
</table>

---

## 🎓 Apple Developer Academy

This project was conceived and developed by **Guilherme Perlasca** and **Laura Klippel** at the **Apple Developer Academy**, where students learn to build apps using Apple technologies following best practices in design, coding, and entrepreneurship.

The latest updates — including Sign in with Apple authentication, the friends-based group system, real-time goal progress calculation, profile management, and comprehensive UI polish — were implemented by **Guilherme Perlasca** to continue evolving the app toward an App Store-ready product.

---

## 📄 License

This project is for educational and portfolio purposes.  
Developed with ❤️ using Swift & SwiftUI.

---

<p align="center">
  <strong>GOMe</strong> — Track goals. Save together. 🎯
</p>
# תוכנית עבודה מפורטת - אפליקציית סטודיו לריקוד
## Detailed Work Plan & Timeline

---

## 🎯 סקירה כללית

**פרויקט**: אפליקציית סטודיו לריקוד
**פלטפורמות**: Flutter (iOS, Android, Web)
**Backend**: Supabase
**זמן כולל**: 11-16 שבועות
**מתודולוגיה**: Agile with 1-week sprints

---

## 📋 Phase 1: MVP (4-6 שבועות)

### Week 1: Project Setup & Foundation
**מטרות השבוע**: הקמת סביבת הפיתוח והתשתית הבסיסית

#### Day 1-2: Environment Setup
- [ ] התקנת Flutter SDK ו-development tools
- [ ] הגדרת Xcode עבור iOS development
- [ ] הגדרת Android Studio עבור Android development
- [ ] יצירת פרויקט Flutter חדש
- [ ] הגדרת Git repository

#### Day 3-4: Supabase Setup
- [ ] יצירת פרויקט Supabase
- [ ] עיצוב מבנה Database (טבלאות ראשוניות)
- [ ] הגדרת Authentication policies
- [ ] יצירת Storage buckets לתמונות וקבצים
- [ ] הגדרת Row Level Security (RLS)

#### Day 5-7: Basic Architecture
- [ ] הגדרת Flutter project structure
- [ ] התקנת packages נדרשים:
  - `supabase_flutter` (Backend)
  - `go_router` (Navigation)
  - `riverpod` (State Management)
  - `cached_network_image` (Image caching)
  - `youtube_player_flutter` (Video player)
- [ ] יצירת base classes ו-models
- [ ] הגדרת themes ו-colors (עיצוב כהה)

**Deliverables**:
✅ פרויקט Flutter מוכן לפיתוח
✅ Supabase מוגדר עם DB structure בסיסי
✅ Git repository מוגדר עם branching strategy

---

### Week 2: Authentication & User Management
**מטרות השבוע**: מערכת משתמשים מלאה

#### Day 1-3: Authentication UI
- [ ] עיצוב מסך הרשמה
  - שדות: שם מלא, מספר טלפון, אימייל, סיסמה
  - ולידציות client-side
  - עיצוב responsive
- [ ] עיצוב מסך התחברות
  - התחברות עם מספר טלפון + סיסמה
  - "זכור אותי" functionality
  - "שכחתי סיסמה" link
- [ ] הוספת אנימציות מעבר בין מסכים

#### Day 4-5: Authentication Logic
- [ ] יישום הרשמה עם Supabase Auth
- [ ] יישום התחברות עם validations
- [ ] מנגנון שחזור סיסמה
- [ ] שמירת מצב התחברות (persistent login)

#### Day 6-7: User Profile Management
- [ ] מסך איזור אישי
- [ ] עריכת פרופיל משתמש
- [ ] העלאת תמונת פרופיל
- [ ] בחירת תפקיד (תלמיד/הורה)
- [ ] שמירת קשרי משפחה (תלמיד-הורה)

**Deliverables**:
✅ מערכת authentication מלאה
✅ ניהול פרופילי משתמשים
✅ UI/UX מושלם למסכי כניסה

---

### Week 3: Home Page & Navigation
**מטרות השבוע**: עמוד הבית וניווט בסיסי

#### Day 1-2: Navigation Structure
**חשוב**: האפליקציה חייבת להיות פשוטה ולא מסובכת!
- [ ] יישום Bottom Navigation Bar (5 כפתורים: בית, עדכונים, גלריה, מדריכים, חנות)
- [ ] יישום Drawer Navigation (המבורגר 3 פסים)
- [ ] הגדרת routes עם go_router
- [ ] App Bar מותאם אישית עם לוגו קבוע בכל עמוד
- [ ] תפריט נפתח כולל: איזור אישי, יצירת קשר, אודות, מועדפים, תקנון ופרטיות, התנתקות

#### Day 3-5: Home Page Development
**🚨 אזהרה חשובה**: אין תוכן MOCK או דמה! הכל מה-DB מההתחלה!
- [ ] ברכת בוקר/ערב דינמית
- [ ] הצגת תמונת פרופיל ושם משתמש מה-DB
- [ ] קטע עדכונים אחרונים מה-DB (3-5 עדכונים אמיתיים)
- [ ] קטע תמונות אחרונות מה-DB (6 תמונות אמיתיות)  
- [ ] קטע מדריכים אחרונים מה-DB (3 מדריכים אמיתיים)
- [ ] מידע על הסטודיו מה-DB
- [ ] כפתורי גישה מהירה לכל המערכות

#### Day 6-7: Responsive Design
- [ ] התאמה למסכי iPhone שונים
- [ ] התאמה למסכי Android שונים
- [ ] התאמה לטאבלטים
- [ ] בדיקת orientation changes

**Deliverables**:
✅ עמוד בית פונקציונלי ומעוצב
✅ מערכת ניווט חלקה
✅ Responsive design מושלם

---

### Week 4: Tutorials System (Frontend + Backend + Admin) 🔄
**מטרות השבוע**: מערכת מדריכים מלאה עם ניהול

#### Day 1-2: Database & Models + Admin Foundation
**🔄 פיצ'ר מלא**: בונים Frontend + Backend + Admin בו-זמנית!
- [ ] יצירת טבלאות:
  - `tutorial_categories`
  - `tutorials`
  - `user_tutorial_progress`
  - `tutorial_views`
  - `tutorial_likes`
- [ ] יצירת Dart models
- [ ] API functions ב-Supabase
- [ ] **Admin Panel**: עמוד ניהול קטגוריות מדריכים (הוספה/עריכה/מחיקה)
- [ ] **Admin Panel**: עמוד ניהול מדריכים (הוספה/עריכה/מחיקה)

#### Day 3-4: Categories & List Views + Admin Categories Management
- [ ] **Frontend**: מסך קטגוריות מדריכים מה-DB (עברית + RTL)
- [ ] **Frontend**: רשימת מדריכים בקטגוריה מה-DB  
- [ ] **Frontend**: Thumbnail images מ-Supabase Storage
- [ ] **Frontend**: מידע בסיסי (שם, משך, צפיות) מה-DB
- [ ] **Admin**: ניהול קטגוריות - CRUD מלא פונקציונלי
- [ ] **בדיקה**: הוספת קטגוריה בAdmin → מופיעה באפליקציה מיידית

#### Day 5-7: Tutorial Player Page + Admin Tutorials Management  
- [ ] **Frontend**: נגן YouTube מובנה (עברית + RTL)
- [ ] **Frontend**: שם המדריך ותיאור מה-DB
- [ ] **Frontend**: מונה צפיות (עדכון אוטומטי ב-DB)
- [ ] **Frontend**: כפתור לייק/unlike (עדכון ב-DB)
- [ ] **Frontend**: כפתור שיתוף
- [ ] **Frontend**: "סמן כנצפה" toggle (שמירה ב-DB)
- [ ] **Frontend**: "הוסף למדריכים שלי" (שמירה ב-DB)
- [ ] **Frontend**: ניווט למדריך הבא/קודם
- [ ] **Admin**: ניהול מדריכים - הוספה/עריכה עם קישור YouTube
- [ ] **Admin**: העלאת תמונות thumbnail
- [ ] **Admin**: ניהול סדר מדריכים בקטגוריה
- [ ] **בדיקה**: הוספת מדריך בAdmin → מופיע באפליקציה מיידית עם כל הפונקציות

**Deliverables**:
✅ מערכת מדריכים פונקציונלית (Frontend + Admin)
✅ נגן YouTube מובנה עם RTL
✅ מעקב אחר פעילות משתמש
✅ פאנל ניהול מדריכים פונקציונלי 100%

---

### Week 5: Gallery System
**מטרות השבוע**: מערכת גלריה מלאה

#### Day 1-2: Database & Structure
- [ ] טבלאות:
  - `gallery_albums`
  - `gallery_images`
  - `image_views`
  - `image_likes`
- [ ] Supabase Storage setup לתמונות
- [ ] Image optimization pipeline

#### Day 3-4: Albums & Grid View
- [ ] מסך אלבומים
- [ ] Grid layout לתמונות
- [ ] Lazy loading
- [ ] Image caching
- [ ] Smooth scrolling

#### Day 5-7: Image Viewer
- [ ] תצוגת תמונה במסך מלא
- [ ] Pinch to zoom
- [ ] מונה צפיות
- [ ] כפתור לייק
- [ ] שיתוף תמונה
- [ ] "הוסף לתמונות שלי"
- [ ] ניווט בין תמונות

**Deliverables**:
✅ מערכת גלריה מלאה
✅ תצוגת תמונות מתקדמת
✅ ביצועים מיטביים

---

### Week 6: Basic Admin Panel
**מטרות השבוע**: פאנל ניהול בסיסי

#### Day 1-3: Web Admin Setup
- [ ] יצירת Flutter Web app נפרד
- [ ] Authentication למנהל
- [ ] Dashboard בסיסי
- [ ] Responsive design

#### Day 4-7: Content Management
- [ ] ניהול קטגוריות מדריכים
- [ ] הוספת/עריכת מדריכים
- [ ] ניהול אלבומי תמונות
- [ ] העלאת תמונות
- [ ] צפייה בסטטיסטיקות בסיסיות

**Deliverables**:
✅ פאנל ניהול בסיסי פונקציונלי
✅ יכולת העלאת תוכן
✅ ממשק ידידותי למנהל

---

## 📋 Phase 2: Enhanced Features (3-4 שבועות)

### Week 7: Store System
**מטרות השבוע**: חנות דיגיטלית

#### Day 1-2: Database & Models
- [ ] טבלאות:
  - `product_categories`
  - `products`
  - `product_likes`
  - `user_saved_products`

#### Day 3-5: Store UI
- [ ] קטגוריות מוצרים
- [ ] רשימת מוצרים
- [ ] עמוד מוצר בודד
- [ ] תמונות איכותיות
- [ ] מידע על מחיר וזמינות

#### Day 6-7: Store Functionality
- [ ] כפתור "קנה עכשיו" (קישור חיצוני)
- [ ] לייקים ושמירה
- [ ] ניווט בין מוצרים
- [ ] מוצרים קשורים

**Deliverables**:
✅ חנות דיגיטלית מלאה
✅ חיבור לקישורי רכישה חיצוניים

---

### Week 8: Updates System
**מטרות השבוע**: מערכת עדכונים

#### Day 1-2: Database & Rich Text
- [ ] טבלאות עדכונים
- [ ] עורך טקסט עשיר
- [ ] תמיכה בתמונות בתוכן

#### Day 3-5: Updates UI
- [ ] רשימת עדכונים
- [ ] קטגוריות עדכונים
- [ ] עמוד עדכון בודד
- [ ] תצוגת תאריך ושעה

#### Day 6-7: Admin Integration
- [ ] יצירת עדכונים בפאנל
- [ ] עורך WYSIWYG
- [ ] תכנון פרסום עדכונים

**Deliverables**:
✅ מערכת עדכונים מלאה
✅ תוכן עשיר ומעוצב

---

### Week 9: Personal Favorites & Push Notifications
**מטרות השבוע**: עמוד מועדפים והתרעות

#### Day 1-3: Personal Favorites Page
- [ ] יצירת עמוד "מועדפים" בתפריט הנפתח
- [ ] מערכת טאבים: מדריכים | תמונות | מוצרים  
- [ ] "המדריכים שלי" - רשימה מה-DB
- [ ] "התמונות שלי" - grid מה-DB  
- [ ] "המוצרים שלי" - רשימה מה-DB
- [ ] ניהול רשימות (הוספה/הסרה) בזמן אמת

#### Day 4-7: Push Notifications
- [ ] הגדרת Firebase Cloud Messaging
- [ ] שליחת הודעות למשתמשים
- [ ] התאמה אישית של הודעות
- [ ] הודעות לפי אירועים (תוכן חדש)

**Deliverables**:
✅ רשימות אישיות פונקציונליות
✅ מערכת הודעות push

---

### Week 10: Drawer Menu Pages
**מטרות השבוע**: השלמת עמודי התפריט הנפתח

#### Day 1-3: Contact Page (מהתפריט הנפתח)
- [ ] מידע קשר (טלפון: 0527274321, אימייל: sharon.art6263@gmail.com, כתובת: השקד 68 בית עזרא)
- [ ] כפתורים לפעולות (התקשרות ישירה, שליחת מייל)
- [ ] שעות פעילות: א'-ה' 11:00-19:00
- [ ] קישור למפות Google

#### Day 4-5: About Page (מהתפריט הנפתח)
- [ ] תוכן דינמי מפאנל הניהול מה-DB
- [ ] תמונות הסטודיו מה-DB
- [ ] היסטוריה ומידע מה-DB

#### Day 6-7: Terms & Privacy Page (מהתפריט הנפתח)
- [ ] תקנון שימוש באפליקציה
- [ ] מדיניות פרטיות
- [ ] זכויות המשתמש
- [ ] התחייבויות הסטודיו

**Deliverables**:
✅ עמודי תוכן מושלמים
✅ מידע מעודכן ונגיש

---

## 📋 Phase 3: Advanced Features (2-3 שבועות)

### Week 11: Advanced UI/UX
**מטרות השבוע**: עיצוב מתקדם ואפקטים

#### Day 1-3: Animations & Transitions
- [ ] אנימציות מעבר בין מסכים
- [ ] Loading animations מתקדמות
- [ ] Micro-interactions
- [ ] Smooth scrolling effects

#### Day 4-5: Advanced UI Components
- [ ] Custom widgets מעוצבים
- [ ] Gradient effects
- [ ] Shadow effects מתקדמים
- [ ] Neumorphism elements

#### Day 6-7: Dark Theme Enhancement
- [ ] שיפור צבעים ונגישות
- [ ] התאמת לוגו לתכלת ורוד
- [ ] אופטימיזציה לצפייה בחושך

**Deliverables**:
✅ UI/UX מתקדם ומרשים
✅ אנימציות חלקות

---

### Week 12: Search & Analytics
**מטרות השבוע**: חיפוש ואנליטיקס

#### Day 1-3: Search Functionality
- [ ] חיפוש גלובלי
- [ ] Auto-complete
- [ ] חיפוש מתקדם עם סינונים
- [ ] היסטוריית חיפושים

#### Day 4-7: Analytics Implementation
- [ ] מעקב אחר אירועים
- [ ] דוחות בפאנל הניהול
- [ ] KPIs בסיסיים
- [ ] גרפים ותרשימים

**Deliverables**:
✅ חיפוש מתקדם
✅ מערכת אנליטיקס

---

## 📋 Phase 4: Polish & Launch (2-3 שבועות)

### Week 13: Quality Assurance
**מטרות השבוע**: בדיקות מקיפות

#### Day 1-2: Functional Testing
- [ ] בדיקת כל user flows
- [ ] בדיקת cross-platform compatibility
- [ ] בדיקת authentication flows
- [ ] בדיקת CRUD operations

#### Day 3-4: Performance Testing
- [ ] בדיקת זמני טעינה
- [ ] בדיקת ניצול זיכרון
- [ ] בדיקת צריכת סוללה
- [ ] Load testing

#### Day 5-7: Device Testing
- [ ] בדיקה במכשירי iPhone שונים
- [ ] בדיקה במכשירי Android שונים
- [ ] בדיקת רשתות שונות
- [ ] בדיקת תרחישי edge cases

**Deliverables**:
✅ אפליקציה נבדקת ויציבה
✅ דוח בדיקות מקיף

---

### Week 14: Optimization & Security
**מטרות השבוע**: אופטימיזציות ואבטחה

#### Day 1-3: Performance Optimization
- [ ] אופטימיזציית שאילתות DB
- [ ] אופטימיזציית תמונות
- [ ] Code splitting
- [ ] Bundle size optimization

#### Day 4-7: Security Hardening
- [ ] בדיקת אבטחת API
- [ ] עדכון RLS policies
- [ ] Input validation hardening
- [ ] Encryption verification

**Deliverables**:
✅ ביצועים מיטביים
✅ אבטחה מקסימלית

---

### Week 15-16: Launch Preparation
**מטרות השבוע**: הכנה להשקה

#### Week 15: Store Preparation
- [ ] הכנת Assets לApp Store (iOS)
  - Screenshots לכל המכשירים
  - App icons בגדלים שונים
  - App description
  - Keywords optimization
- [ ] הכנת Assets לGoogle Play (Android)
  - Screenshots ו-feature graphics
  - Store listing optimization
  - App description בעברית ואנגלית
- [ ] הגשה לביקורת App Store
- [ ] העלאה לGoogle Play Console

#### Week 16: Final Launch
- [ ] הכנת Netlify deployment
- [ ] DNS configuration
- [ ] SSL certificates
- [ ] Final testing בסביבת production
- [ ] מעקב אחר ביקורת חנויות
- [ ] השקה רשמית
- [ ] הכשרת המנהלת לשימוש בפאנל

**Deliverables**:
✅ אפליקציה זמינה בחנויות
✅ אתר web פעיל
✅ פאנל ניהול מוכן לשימוש

---

## 🛠️ דרישות טכניות מפורטות

### Flutter Packages (Main Dependencies)
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.5.6
  go_router: ^13.2.1
  riverpod: ^2.5.1
  flutter_riverpod: ^2.5.1
  cached_network_image: ^3.3.1
  youtube_player_flutter: ^8.1.2
  image_picker: ^1.0.7
  share_plus: ^7.2.2
  url_launcher: ^6.2.5
  firebase_messaging: ^14.7.19
  flutter_local_notifications: ^17.0.0
  shimmer: ^3.0.0
  lottie: ^3.1.0
  google_fonts: ^6.1.0
  flutter_staggered_grid_view: ^0.7.0
  photo_view: ^0.14.0
  html_editor_enhanced: ^2.5.1
```

### Supabase Schema (Main Tables)
```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  phone TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  address TEXT,
  role TEXT CHECK (role IN ('student', 'parent')) DEFAULT 'student',
  parent_name TEXT,
  student_name TEXT,
  profile_image TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tutorial categories
CREATE TABLE tutorial_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  cover_image TEXT,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tutorials
CREATE TABLE tutorials (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  youtube_url TEXT NOT NULL,
  thumbnail TEXT,
  category_id UUID REFERENCES tutorial_categories(id),
  sort_order INTEGER DEFAULT 0,
  view_count INTEGER DEFAULT 0,
  like_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- User tutorial interactions
CREATE TABLE user_tutorial_interactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  tutorial_id UUID REFERENCES tutorials(id),
  is_liked BOOLEAN DEFAULT false,
  is_saved BOOLEAN DEFAULT false,
  is_watched BOOLEAN DEFAULT false,
  view_count INTEGER DEFAULT 0,
  last_watched TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(user_id, tutorial_id)
);

-- Similar structure for gallery, products, updates...
```

### File Structure
```
dance_studio_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── themes/
│   │   ├── utils/
│   │   └── services/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── models/
│   │   │   ├── providers/
│   │   │   ├── services/
│   │   │   └── screens/
│   │   ├── home/
│   │   ├── tutorials/
│   │   ├── gallery/
│   │   ├── store/
│   │   ├── updates/
│   │   └── profile/
│   ├── shared/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── services/
│   │   └── widgets/
│   └── router/
├── assets/
│   ├── images/
│   ├── icons/
│   └── animations/
├── web/
├── ios/
├── android/
└── admin_panel/ (separate Flutter web app)
```

---

## 📊 מדדי הצלחה (Success Metrics)

### Week 1-2 Goals:
- ✅ פרויקט מוגדר עם כל התשתית
- ✅ מערכת משתמשים פועלת 100%
- ✅ עיצוב בסיסי מיושם

### Week 3-6 Goals:
- ✅ MVP מלא פונקציונלי
- ✅ 3 מערכות תוכן עובדות (מדריכים, גלריה, בית)
- ✅ פאנל ניהול בסיסי

### Week 7-10 Goals:
- ✅ כל התכונות המוגדרות פעילות
- ✅ Push notifications פועלות
- ✅ רשימות אישיות

### Week 11-16 Goals:
- ✅ UI/UX מושלם ומתקדם
- ✅ אפליקציה בחנויות
- ✅ מוכן לשימוש בפרודוקשן

---

## 🚨 נקודות קריטיות לתשומת לב

### חובה לזכור - הכי חשוב!!!:
1. **🔄 פיצ'ר מלא מהתחלה עד הסוף**: כל פיצ'ר נבנה ב-Frontend + Backend + Admin Panel באותו זמן!
   - בניתי עמוד מדריכים → בונה גם עמוד ניהול מדריכים
   - בניתי עמוד עדכונים → בונה גם עמוד ניהול עדכונים  
   - בניתי עמוד גלריה → בונה גם עמוד ניהול גלריה
   - **הכל חייב להיות מחובר ל-DB ו-100% פונקציונלי מהרגע הראשון!**

2. **🚫 אין תוכן MOCK/דמה**: הכל מה-DB מההתחלה - זה קריטי!

3. **🇮🇱 עברית מלאה + RTL**: כל האפליקציה בעברית עם תמיכה מימין לשמאל!

4. **🎯 פשטות**: האפליקציה חייבת להיות פשוטה ולא מסובכת

5. **🏠 לוגו בכל עמוד**: בחלק העליון של כל מסך

6. **🧭 מבנה ניווט קבוע**: Bottom nav (5 כפתורים) + Drawer (6 פריטים)

7. **✅ מעקב משימות**: לסמן כל משימה שמושלמת בתוכנית

8. **Dark Theme**: עיצוב כהה מעוצב לאורך כל הפרויקט

9. **Performance**: אופטימיזציה מתמדת, במיוחד לתמונות וסרטונים

10. **Security**: RLS policies חזקות ב-Supabase

11. **User Experience**: כל אינטראקציה חייבת להיות חלקה ומהירה

### סיכונים וטיפול בהם:
- **יוטיוב API limits**: יש להגדיר fallback mechanisms
- **תמונות כבדות**: compression אוטומטי בהעלאה
- **חיבור איטי**: offline support בסיסי
- **אבטחת נתונים**: encryption בכל השכבות

---

## ✅ סיכום תוכנית העבודה

**סה"כ זמן**: 11-16 שבועות
**מספר Sprints**: 16 sprints שבועיים
**תוצרים עיקריים**: 
- 📱 אפליקציית mobile (iOS + Android)
- 🌐 אפליקציית web responsive  
- ⚙️ פאנל ניהול web admin
- 📊 מערכת אנליטיקס
- 🔔 מערכת push notifications

**נקודת סיום**: אפליקציה מושלמת, מפורסמת בחנויות, מוכנה לשימוש מסחרי עם תמיכה מלאה.

**הערה חשובה**: תוכנית זו בנויה בצורה אגילית ומאפשרת התאמות תוך כדי הפיתוח לפי צרכים שיתגלו.

---

## 🎯 המשך לשלב הבא

**מוכן להתחיל בפיתוח**! 
הצעה לשלב הבא: יצירת מבנה הפרויקט והגדרת הסביבה הטכנית לפי השלב הראשון בתוכנית העבודה.
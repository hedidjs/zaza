# 📋 מעקב משימות - אפליקציית סטודיו לריקוד
## Task Tracker & Progress Monitoring

---

## 🎯 Phase 1: MVP (4-6 שבועות) - CURRENT PHASE

### Week 1: Project Setup & Foundation ⏳

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
- [ ] התקנת packages נדרשים
- [ ] יצירת base classes ו-models
- [ ] הגדרת themes ו-colors (עיצוב כהה)

**Status Week 1**: ⏳ NOT STARTED
**Deliverables**: 
- ✅ פרויקט Flutter מוכן לפיתוח
- ✅ Supabase מוגדר עם DB structure בסיסי  
- ✅ Git repository מוגדר עם branching strategy

---

### Week 2: Authentication & User Management ⏳

#### Day 1-3: Authentication UI
- [ ] עיצוב מסך הרשמה (שדות חובה + ולידציות)
- [ ] עיצוב מסך התחברות (טלפון + סיסמה)
- [ ] הוספת אנימציות מעבר בין מסכים
- [ ] עיצוב responsive לכל המסכים

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

**Status Week 2**: ⏳ NOT STARTED
**Deliverables**:
- ✅ מערכת authentication מלאה
- ✅ ניהול פרופילי משתמשים
- ✅ UI/UX מושלם למסכי כניסה

---

### Week 3: Home Page & Navigation ⏳

#### Day 1-2: Navigation Structure  
**🚨 חשוב**: האפליקציה חייבת להיות פשוטה ולא מסובכת!
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

**Status Week 3**: ⏳ NOT STARTED
**Deliverables**:
- ✅ עמוד בית פונקציונלי ומעוצב
- ✅ מערכת ניווט חלקה
- ✅ Responsive design מושלם

---

### Week 4: Tutorials System ⏳

#### Day 1-2: Database & Models
- [ ] יצירת טבלאות: tutorial_categories, tutorials, user_tutorial_progress, tutorial_views, tutorial_likes
- [ ] יצירת Dart models
- [ ] API functions ב-Supabase

#### Day 3-4: Categories & List Views  
- [ ] מסך קטגוריות מדריכים מה-DB
- [ ] רשימת מדריכים בקטגוריה מה-DB
- [ ] Thumbnail images מה-Storage
- [ ] מידע בסיסי (שם, משך, צפיות) מה-DB

#### Day 5-7: Tutorial Player Page
- [ ] נגן YouTube מובנה (ללא יציאה מהאפליקציה)
- [ ] שם המדריך ותיאור מה-DB
- [ ] מונה צפיות (אוטומטי עדכון ב-DB)
- [ ] כפתור לייק/unlike (עדכון ב-DB)
- [ ] כפתור שיתוף
- [ ] "סמן כנצפה" toggle (שמירה ב-DB)
- [ ] "הוסף למדריכים שלי" (שמירה ב-DB)
- [ ] ניווט למדריך הבא/קודם

**Status Week 4**: ⏳ NOT STARTED
**Deliverables**:
- ✅ מערכת מדריכים פונקציונלית
- ✅ נגן YouTube מובנה
- ✅ מעקב אחר פעילות משתמש

---

### Week 5: Gallery System ⏳

#### Day 1-2: Database & Structure
- [ ] טבלאות: gallery_albums, gallery_images, image_views, image_likes
- [ ] Supabase Storage setup לתמונות
- [ ] Image optimization pipeline

#### Day 3-4: Albums & Grid View
- [ ] מסך אלבומים מה-DB
- [ ] Grid layout לתמונות מה-DB
- [ ] Lazy loading
- [ ] Image caching
- [ ] Smooth scrolling

#### Day 5-7: Image Viewer
- [ ] תצוגת תמונה במסך מלא
- [ ] Pinch to zoom
- [ ] מונה צפיות (עדכון אוטומטי ב-DB)
- [ ] כפתור לייק (עדכון ב-DB)
- [ ] שיתוף תמונה
- [ ] "הוסף לתמונות שלי" (שמירה ב-DB)
- [ ] ניווט בין תמונות

**Status Week 5**: ⏳ NOT STARTED
**Deliverables**:
- ✅ מערכת גלריה מלאה
- ✅ תצוגת תמונות מתקדמת  
- ✅ ביצועים מיטביים

---

### Week 6: Basic Admin Panel ⏳

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

**Status Week 6**: ⏳ NOT STARTED
**Deliverables**:
- ✅ פאנל ניהול בסיסי פונקציונלי
- ✅ יכולת העלאת תוכן
- ✅ ממשק ידידותי למנהל

---

## 📊 Current Progress Summary

### Overall Progress: 0% ⏳
**Current Week**: Week 1 - Project Setup & Foundation
**Current Task**: Environment Setup
**Next Milestone**: Complete Flutter + Supabase setup

### Key Requirements Status:
- 🔄 **Complete Feature Development**: ✅ Frontend + Backend + Admin for every feature
- 🚫 **No Mock Data**: ✅ Planned in all phases
- 🇮🇱 **Hebrew + RTL**: ✅ Full support throughout
- 🎯 **Simple Design**: ✅ Emphasized throughout  
- 🏠 **Logo on Every Page**: ✅ Planned in navigation
- 🧭 **Fixed Navigation Structure**: ✅ Defined (5 bottom + 6 drawer)
- ✅ **Task Tracking**: 📋 This document created!

### Ready to Start:
**Next Action**: Begin Week 1, Day 1-2 Environment Setup

---

## 🎯 Instructions for Using This Tracker

1. **Mark Completed Tasks**: Change `[ ]` to `[x]` when done
2. **Update Status**: Change ⏳ to ✅ when week/phase complete  
3. **Add Notes**: Add comments or issues encountered
4. **Daily Updates**: Update progress every day
5. **Deliverable Tracking**: Mark deliverables as completed

**This tracker will be updated continuously as we progress through the development phases.**
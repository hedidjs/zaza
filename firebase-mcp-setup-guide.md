# מדריך התקנה וחיבור Firebase MCP ל-Claude Code

## סטטוס נוכחי
❌ Firebase MCP עדיין לא מחובר - אין פונקציות Firebase זמינות כרגע

## שלבי התקנה

### שלב 1: איתור קובץ ההגדרות
קובץ ההגדרות של Claude Code נמצא במיקום:
```
~/.config/claude-desktop/claude_desktop_config.json
```

### שלב 2: עריכת קובץ ההגדרות
פתח את הקובץ ב-editor (למשל nano או VS Code):
```bash
nano ~/.config/claude-desktop/claude_desktop_config.json
```

### שלב 3: הוספת הגדרות Firebase MCP
הוסף או ערוך את התוכן הבא:

```json
{
  "mcpServers": {
    "firebase": {
      "command": "npx",
      "args": [
        "-y",
        "@gannonh/firebase-mcp"
      ],
      "env": {
        "GOOGLE_APPLICATION_CREDENTIALS": "/Users/rontzarfati/Downloads/studio-xx-firebase-adminsdk-fbsvc-2dda0a8c31.json"
      }
    }
  }
}
```

**הערה:** אם יש לך כבר mcpServers מוגדרים, הוסף רק את החלק של "firebase" בתוך האובייקט הקיים.

### שלב 4: שמירה ואתחול
1. שמור את הקובץ (Ctrl+O ב-nano, או Cmd+S ב-VS Code)
2. סגור את Claude Code לגמרי
3. פתח את Claude Code מחדש

### שלב 5: בדיקת התקנה
לאחר האתחול, הפעל את הפקודה הבאה ב-Claude Code:
```
ListMcpResourcesTool
```

אם הכל עבד, תראה רשימה של פונקציות Firebase זמינות.

## מה אפשר לעשות עם Firebase MCP?

### פונקציות Authentication
- ניהול משתמשים
- יצירת משתמשים חדשים
- עדכון פרטי משתמש
- מחיקת משתמשים

### עבודה עם Firestore
- קריאת מסמכים
- כתיבת מסמכים
- עדכון מסמכים
- מחיקת מסמכים
- שאילתות מורכבות

### ניהול Storage
- העלאת קבצים
- מחיקת קבצים
- קבלת URLs לקבצים

## פרטי הפרויקט
- **Project ID:** studio-xx
- **Service Account:** firebase-adminsdk-fbsvc@studio-xx.iam.gserviceaccount.com
- **קובץ האישורים:** /Users/rontzarfati/Downloads/studio-xx-firebase-adminsdk-fbsvc-2dda0a8c31.json

## פתרון בעיות

### אם ה-MCP לא עובד:
1. ודא שהנתיב לקובץ האישורים נכון
2. ודא שיש לך הרשאות קריאה לקובץ האישורים
3. בדוק שה-syntax של JSON תקין
4. נסה לאתחל את Claude Code שוב

### אם יש שגיאות רשת:
- ודא חיבור לאינטרנט
- בדוק שה-Firebase project פעיל

### אם יש שגיאות הרשאות:
- ודא שהService Account יש לו הרשאות מתאימות בפרויקט Firebase

## דוגמאות שימוש
לאחר התקנה מוצלחת, תוכל להשתמש בפקודות כמו:
- `firebase_auth_list_users` - רשימת משתמשים
- `firebase_firestore_get_document` - קריאת מסמך
- `firebase_firestore_set_document` - כתיבת מסמך

---
**מוכן להשתמש!** 🔥
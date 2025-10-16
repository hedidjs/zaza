import fs from "fs";
import jwt from "jsonwebtoken";

// פרטים מהחשבון שלך
const teamId = "S5J2HM87A7";               // Team ID
const clientId = "com.sharonstudio.studioxx.auth"; // Service ID (Client ID)
const keyId = "J96WAV8HHW";                // Key ID
const privateKey = fs.readFileSync("./AuthKey_J96WAV8HHW.p8"); // הקובץ שהורדת

// מייצרים JWT תקף ל-6 חודשים
const token = jwt.sign(
  {
    iss: teamId,
    iat: Math.floor(Date.now() / 1000),
    exp: Math.floor(Date.now() / 1000) + 15777000, // חצי שנה קדימה
    aud: "https://appleid.apple.com",
    sub: clientId,
  },
  privateKey,
  {
    algorithm: "ES256",
    keyid: keyId,
  }
);

console.log("Apple Client Secret:\n", token);
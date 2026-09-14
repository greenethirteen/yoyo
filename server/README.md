# Yoyo lesson proxy

A tiny server that generates mini lessons for the Yoyo app using OpenAI.
It exists so the OpenAI API key stays on the server and is **never shipped inside the iOS app**.

## Run locally

```bash
cd server
npm install
cp .env.example .env        # then edit .env and paste your ROTATED key
npm start                   # -> http://localhost:8787
```

Quick check:

```bash
curl -s http://localhost:8787/health
```

## Endpoint

`POST /lesson`

```json
{
  "stem": "Which feature is found in a plant cell but not in an animal cell?",
  "options": ["Cell membrane", "Cytoplasm", "Cellulose cell wall", "Ribosome"],
  "correctIndex": 2,
  "topic": "Cell structure"
}
```

Returns:

```json
{ "title": "...", "body": "...", "tip": "..." }
```

## Talking to it from the app

- **Simulator:** `http://localhost:8787` works as-is.
- **Physical iPad:** use your Mac's LAN address, e.g. `http://192.168.1.50:8787`
  (run `ipconfig getifaddr en0` to find it), and make sure both are on the same network.

Set the address in `LessonService.baseURL` in the app.

## Before shipping to real users

- Deploy this to a host (Render, Railway, Fly.io, a VPS, etc.) behind **HTTPS**.
- Put the OpenAI key in the host's secret/environment settings.
- Point `LessonService.baseURL` at the HTTPS URL and remove the ATS exception from `Info.plist`.
- Consider adding auth / rate limiting so only your app can call it.

import "dotenv/config";
import express from "express";
import OpenAI from "openai";
import path from "path";
import { fileURLToPath } from "url";

const app = express();
app.use(express.json());
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
app.use(express.static(path.join(__dirname, "public")));

const LETTERS = ["A", "B", "C", "D", "E", "F"];
const SYSTEM_PROMPT = "You are a friendly science tutor writing for a grade 6 or 7 student. Given a multiple-choice question and its correct answer, write a very short mini lesson. Use simple words and explain each answer choice so the student understands what every option means. Respond ONLY as JSON with exactly these keys: \"title\", \"body\", \"tip\", \"optionExplanations\". Use British spelling.";

app.get("/health", (_req, res) => res.json({ ok: true }));
app.post("/lesson", async (req, res) => {
  const { stem, options, correctIndex, topic } = req.body ?? {};
  if (typeof stem !== "string" || !Array.isArray(options) || typeof correctIndex !== "number" || correctIndex < 0 || correctIndex >= options.length) return res.status(400).json({ error: "Invalid request body" });

  if (!process.env.OPENAI_API_KEY) {
    return res.status(503).json({ error: "Lesson generation is not configured" });
  }

  try {
    const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    const completion = await client.chat.completions.create({ model: "gpt-4o-mini", temperature: 0.4, response_format: { type: "json_object" }, messages: [
      { role: "system", content: SYSTEM_PROMPT },
      { role: "user", content: JSON.stringify({ topic: topic ?? "", question: stem, options: options.map((o, i) => `${LETTERS[i]}. ${o}`), correctAnswer: `${LETTERS[correctIndex]}. ${options[correctIndex]}` }) }
    ]});
    const parsed = JSON.parse(completion.choices[0]?.message?.content ?? "{}");
    res.json({ title: String(parsed.title ?? topic ?? ""), body: String(parsed.body ?? ""), tip: String(parsed.tip ?? ""), optionExplanations: Array.isArray(parsed.optionExplanations) ? parsed.optionExplanations.map(String) : [] });
  } catch (err) { console.error("Generation failed:", err?.message ?? err); res.status(502).json({ error: "Generation failed" }); }
});

const port = process.env.PORT || 8787;
app.listen(port, () => console.log(`Yoyo server listening on port ${port}`));

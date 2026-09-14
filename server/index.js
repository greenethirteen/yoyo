import "dotenv/config";
import express from "express";
import OpenAI from "openai";

const app = express();
app.use(express.json());

// The API key lives here, on the server — never in the iOS app.
// It is read from the environment so it is never committed to source control.
const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

const LETTERS = ["A", "B", "C", "D", "E", "F"];

const SYSTEM_PROMPT =
  "You are a friendly science tutor writing for a grade 6 or 7 student. " +
  "Given a multiple-choice question and its correct answer, write a very short mini lesson. " +
  "Use simple words and explain each answer choice so the student understands what every option means. " +
  "Respond ONLY as JSON with exactly these keys: " +
  "\"title\" (a short heading, max 6 words), " +
  "\"body\" (1-2 short, clear sentences, plain prose, no markdown), " +
  "\"tip\" (one short sentence hint the student can remember), " +
  "\"optionExplanations\" (an array with one simple sentence for each answer option, in the same order). " +
  "Use British spelling.";

app.get("/health", (_req, res) => res.json({ ok: true }));

app.post("/lesson", async (req, res) => {
  const { stem, options, correctIndex, topic } = req.body ?? {};

  if (
    typeof stem !== "string" ||
    !Array.isArray(options) ||
    typeof correctIndex !== "number" ||
    correctIndex < 0 ||
    correctIndex >= options.length
  ) {
    return res.status(400).json({ error: "Invalid request body" });
  }

  try {
    const completion = await client.chat.completions.create({
      model: "gpt-4o-mini",
      temperature: 0.4,
      response_format: { type: "json_object" },
      messages: [
        { role: "system", content: SYSTEM_PROMPT },
        {
          role: "user",
          content: JSON.stringify({
            topic: topic ?? "",
            question: stem,
            options: options.map((o, i) => `${LETTERS[i]}. ${o}`),
            correctAnswer: `${LETTERS[correctIndex]}. ${options[correctIndex]}`,
          }),
        },
      ],
    });

    const raw = completion.choices[0]?.message?.content ?? "{}";
    const parsed = JSON.parse(raw);

    res.json({
      title: String(parsed.title ?? topic ?? ""),
      body: String(parsed.body ?? ""),
      tip: String(parsed.tip ?? ""),
      optionExplanations: Array.isArray(parsed.optionExplanations)
        ? parsed.optionExplanations.map((explanation) => String(explanation))
        : [],
    });
  } catch (err) {
    console.error("Generation failed:", err?.message ?? err);
    res.status(502).json({ error: "Generation failed" });
  }
});

const port = process.env.PORT || 8787;
app.listen(port, () => {
  console.log(`Yoyo lesson proxy listening on http://localhost:${port}`);
});

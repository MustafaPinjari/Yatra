# YATRA — Project Development Guidelines & Mandatory Standards

## Mandatory Project Instruction: Unslop Skill Enforcement

Before writing or editing any English text intended for human readers, load and apply the Unslop skill (`~/.gemini/config/skills/unslop/SKILL.md`). Follow its complete instructions and reference materials. Do not merely replace individual AI-sounding words. Apply its typography, vocabulary, structural and epistemic principles.

---

### Level 1: Typography and Mechanics
- **Sentence Case Everywhere**: Use sentence case for UI labels, table headers, tabs, and buttons instead of ALL-CAPS tracked text (e.g. `Delhi Transit Atlas` instead of `DELHI TRANSIT ATLAS`, `Step-free access` instead of `ACCESSIBLE`).
- **No Exclamation Marks**: Interface copy must never use exclamation marks (`!`) or double exclamations (`!!`). State facts plainly.
- **No Trailing Periods on Short Strings**: Headings, subheads, labels, buttons, captions, and short status pills end without a period. Only multi-sentence body paragraphs retain periods.
- **Numbers & Metrics**: Use tabular figures (`tabular-nums`) and consistent formatting across the screen.

---

### Level 2: Vocabulary and Rhetoric
- **Remove AI Clichés & Buzzwords**: Eliminate "seamless", "revolutionize", "supercharge", "unlock", "empower", "magic", "effortless", "game-changing", and "AI-powered" on everything.
- **No Artificial Greetings**: Avoid greeting headlines such as `Welcome back! 👋` or empty conversational phrases. The headline names the context or action.
- **Direct, Concise Inputs & Placeholders**: Use `Search routes or stops` instead of `Search anything...` or `Search accessible routes or stops...`.
- **Grounded Comparison for Metrics**: Every change or percentage must state what it compares to (e.g. `+1.8% over last quarter`, not `10x faster`).
- **Plausible Data**: Mock and sample data must reflect real operational values, route numbers, and stops across Delhi.

---

### Level 3: Structure and Epistemics
- **Natural, Varied Composition**: Avoid rigid claim-evidence-conclusion templates. Write clearly and factually.
- **Zero Hallucination or Unsupported Claims**: Never invent statistics, coverage numbers, operational capabilities, or compliance guarantees.
- **Audience-Specific Adaptation**:
  - **Passengers**: Direct, simple, and easy to understand during transit.
  - **Accessibility Users**: Respectful, dignified, non-patronizing, and functional (e.g., focus on physical ramp deployment, curb clearance, tactile paths, audio announcements).
  - **Drivers**: Concise, high-contrast operational instructions that minimize cab distraction.
  - **Operators & Dispatchers**: Precise operational language, unambiguous status codes, and exact headway intervals.
  - **Government & Municipal Authorities**: Factual, analytical, and audit-verifiable data under the Delhi Transit Stack.
  - **Developers**: Technically accurate documentation, schemas, and API contracts.

---

### Code and Functionality Protection
Unslop governs human-facing writing, not code refactoring. Never alter:
- Variable names, function names, class names, or API contracts.
- Database schemas, table columns, or JSON keys.
- Route paths, translation keys, or technical protocol names.
- Delhi Transport Corporation official terminology (e.g. DTC, ISBT, ETM, DIMTS, GTFS-Realtime).
- Accessibility semantics, screen-reader announcements, and Semantics widget labels.

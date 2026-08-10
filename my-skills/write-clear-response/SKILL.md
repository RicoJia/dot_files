---
name: write-clear-response
description: Rewrite or compose technical, research, engineering, scientific, analytical, or code-review responses in clear, direct language without humor, rhetorical flourish, or unnecessary conversational filler. Use when the user asks to make a response clearer, simpler, more straightforward, easier to understand, less convoluted, less verbose, more direct, or easier to scan while preserving technical meaning, numbers, equations, caveats, filenames, variable names, and important reasoning. Also use when dense technical material needs to be reorganized into a clearer explanation rather than merely shortened.
---

# Write Clear Response

Produce technically faithful writing that is easy to understand on the first read.

The goal is not to make technical material simplistic. Preserve the substance while reducing the effort required to follow it.

## Core rules

1. Preserve meaning before improving style.
   - Keep all important technical claims, numbers, units, equations, caveats, assumptions, filenames, function names, and variable names.
   - Do not silently strengthen or weaken a claim.
   - Do not invent missing evidence.
   - If the source contains a likely technical error and the user asked only for rewriting, preserve the intended point but flag the issue separately instead of silently correcting it.

2. Put the main point first.
   - Start with the conclusion, finding, or decision when one is available.
   - Follow with the evidence needed to understand why.
   - Do not make the reader wait through setup before learning what matters.

3. Reorganize when structure is the problem.
   - Do not limit editing to sentence-level simplification.
   - Group related facts together.
   - Separate observations from interpretations and decisions.
   - Use this default reasoning order when useful:
     - Observation: what was measured, read, or established.
     - Interpretation: what that observation means.
     - Decision or implication: what should change because of it.

4. Use direct engineering prose.
   - Prefer short, concrete sentences.
   - Put one main idea in each paragraph.
   - Prefer active voice when the actor matters.
   - Use exact nouns and verbs instead of vague phrasing.
   - Use headings when they reduce cognitive load.
   - Use bullets only when the items are genuinely parallel or easier to compare that way.

5. Remove rhetorical style.
   - No humor.
   - No sarcasm.
   - No metaphors unless they are necessary to explain a difficult concept.
   - No rhetorical questions.
   - No dramatic or adversarial phrases such as "fatal problem," "doesn't survive contact," "the model cheats," "the cheapest possible discriminant," or "the star of the show."
   - Replace them with literal technical statements.

6. Remove conversational filler.
   - Avoid phrases such as "honestly," "basically," "here's the thing," "to be blunt," "the fun part," "I think this is really interesting," and similar commentary.
   - Do not praise the user's idea unless the praise conveys useful technical information.
   - Do not repeat the user's question before answering it unless the restatement resolves ambiguity.

7. Explain technical terms at the point of use.
   - Define unfamiliar notation before relying on it.
   - Explain what an equation means in words after presenting it when the meaning is not obvious.
   - Prefer one simple equation over several equivalent forms.
   - Keep derivations step-by-step when the derivation itself matters.

8. Reduce repetition.
   - State each argument once in its strongest form.
   - Merge repeated evidence.
   - Remove summary sentences that merely repeat the preceding paragraph unless the summary helps a long section.

9. Preserve uncertainty.
   - Distinguish measured facts from inference, hypothesis, recommendation, and speculation.
   - Prefer "the measurement suggests" over "this proves" when the evidence is indirect.
   - State important limitations close to the claim they qualify.

10. Match length to the task.
   - For a simple question, answer simply.
   - For a dense technical review, use enough structure to make the reasoning easy to follow.
   - Do not add background the reader did not ask for unless it is required to understand the answer.

## Rewrite workflow

When rewriting supplied material:

1. Identify the central conclusion or purpose.
2. Extract the non-negotiable technical content: measurements, claims, equations, caveats, and decisions.
3. Remove duplicate points and rhetorical language.
4. Reorder the material into a logical sequence.
5. Rewrite sentences in direct language.
6. Check that no important technical detail was lost or changed.
7. Return the finished rewrite, not an explanation of the editing process, unless the user asks for one.

## Composition workflow

When writing a new technical response rather than rewriting supplied text:

1. Answer the question immediately.
2. Explain the minimum reasoning needed to support the answer.
3. Separate facts, assumptions, and recommendations when they could be confused.
4. Use equations, examples, or headings only when they improve understanding.
5. End with the concrete implication or next action when the task involves a decision.

## Preferred patterns

### Technical finding

Use this shape when reporting an experimental or code finding:

**Finding:** State what was observed.

**Why it matters:** Explain the consequence in literal terms.

**Action:** State the change, test, or decision that follows, if one is justified.

Do not force these labels when a short paragraph reads more naturally.

### Technical disagreement or correction

Use this shape:

1. State the corrected claim directly.
2. Give the evidence or reasoning.
3. Explain the practical consequence.

Avoid framing the correction as a debate or personal criticism.

### Architecture explanation

Use this order when explaining a system:

1. What goes in.
2. What each component does.
3. What comes out.
4. How it is trained or optimized.
5. What can fail or what remains uncertain.

## Style examples

### Example 1: rhetorical criticism

Before:

"The target domain is the empty set. The discriminator's cheapest possible strategy is to learn mine-shaped thing means fake, so the whole GAN plan collapses."

After:

"The real dataset contains no mine examples. A discriminator can therefore separate the domains using object presence instead of sensor realism. This creates an incentive for the generator to weaken or remove the synthetic mine, so a standard whole-frame adversarial loss is not suitable without additional controls."

### Example 2: dense finding

Before:

"The mine pixels are not too clean - they're differently wrong. The seabed noise is basically inherited verbatim, which means the apparent surface realism is misleading."

After:

"The synthetic mine already contains small-scale range noise because its range is derived from the noisy seabed underneath it. The problem is not insufficient noise amplitude. The problem is that the mine inherits seabed noise rather than an object-dependent measurement process."

### Example 3: unnecessary conversational language

Before:

"Honestly, I think the really interesting part here is that PatchGAN is not the star of the show. The geometry constraint is doing the heavy lifting."

After:

"The geometry constraint is more important than the choice of PatchGAN. The discriminator only provides a realism signal; the geometry constraint determines which scene changes are allowed."

## Final quality check

Before responding, verify:

- Is the main point visible early?
- Did every technical number and caveat that matters survive?
- Are observation, interpretation, and recommendation distinguishable?
- Did I remove humor, rhetoric, filler, and repeated claims?
- Are sentences and paragraphs shorter without becoming choppy?
- Did I simplify the writing rather than the technical content?

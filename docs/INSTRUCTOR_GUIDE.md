# Instructor's Guide: The First Steps After Receiving a Dataset

## Pre-Workshop Preparation

### 1. Technical Setup (1 day before)
- [ ] Test R Markdown renders correctly on your machine
- [ ] Ensure all packages are installed and working
- [ ] Prepare backup of rendered HTML in case of technical issues
- [ ] Test projector/screen sharing setup

### 2. Room Setup (30 min before)
- [ ] Check WiFi connectivity
- [ ] Have backup USB with materials
- [ ] Prepare whiteboard/flipchart for DAG drawing

---

## Workshop Flow and Timing

| Time | Section | Duration | Notes |
|------|---------|----------|-------|
| 13:00 | Introduction & Setup | 10 min | Get everyone's R working |
| 13:10 | Defining Variables | 20 min | Emphasize "question first" |
| 13:30 | Statistical Analysis Plan | 20 min | Show real SAP examples |
| 13:50 | **BREAK** | 10 min | |
| 14:00 | Data Cleaning | 30 min | Live coding, lots of interaction |
| 14:30 | EDA | 20 min | Table 1 is key deliverable |
| 14:50 | **BREAK** | 10 min | |
| 15:00 | Missing Data & Recoding | 20 min | MICE can be slow - be patient |
| 15:20 | **Statistical Analysis** | 30 min | Logistic + Cox regression |
| 15:50 | Q&A + Wrap-up | 10 min | |

---

## Teaching Tips by Section

### Section 1: Introduction (10 min)
**Goal:** Everyone has working R environment

- Have students run the package loading chunk first
- Common issues: missing packages, old R versions
- Backup plan: Share pre-rendered HTML for following along

**Discussion prompt:**
> "How many of you have received a dataset and immediately started running regressions?"

### Section 2: Defining Variables (25 min)
**Goal:** Establish "research question first" mindset

**Key points to emphasize:**
1. Variable definitions should come BEFORE looking at the data
2. Draw a simple DAG on the whiteboard
3. Mediator vs. confounder distinction is critical

**Exercise 1 discussion points:**
- LDL as mediator: "Statins work BY lowering LDL, so if we adjust for LDL, we remove the very effect we're trying to measure"
- This is a common mistake in pharmacoepidemiology

### Section 3: SAP (25 min)
**Goal:** Understand why pre-registration matters

**Key points:**
1. SAP prevents p-hacking and HARKing
2. Journals increasingly require pre-registration
3. It protects YOU from reviewers asking "why didn't you adjust for X?"

**Real-world tip:**
> "Your SAP doesn't have to be perfect. The goal is to commit to your main analysis BEFORE you see the results."

### Section 4: Data Cleaning (35 min)
**Goal:** Systematic approach to data quality

**Live coding tips:**
- Run code in small chunks, discuss each output
- Ask students to predict what issues we'll find
- Emphasize DOCUMENTATION - the cleaning log is as important as the code

**Common student questions:**
- "What if I can't tell which duplicate is correct?" → Go back to the data source, or exclude both
- "How do I decide what's an outlier?" → Clinical plausibility, not statistical cutoffs

**Exercise 3 emphasis:**
- The `education = "Unknown"` is a judgment call - discuss pros/cons of treating as NA

### Section 5: EDA (30 min)
**Goal:** Systematic exploration before modeling

**Key deliverable:** Table 1

**Teaching points:**
1. Table 1 is required for virtually every observational study paper
2. Show how `gtsummary` makes this easy
3. Discuss what p-values in Table 1 mean (or don't mean)

**Common pitfall to mention:**
> "EDA should not become a fishing expedition. Look at your variables systematically, but remember your pre-specified analysis."

### Section 6: Missing Data (25 min)
**Goal:** Appropriate missing data handling

**Key points:**
1. Always assess missing patterns FIRST
2. Complete case analysis is often biased
3. Multiple imputation is the gold standard for MAR

**MICE tips:**
- The imputation step can take 1-2 minutes
- Explain that m=5 is for demo; use m=20+ in real analysis
- Convergence plots should show stable, intermixed lines

**Common question:**
> "When should I NOT impute?"
> Answer: When missingness is clearly MNAR (e.g., patients too sick to complete follow-up), or when >40-50% is missing

### Section 7: Statistical Analysis (30 min)
**Goal:** Complete the workflow from data to inference

**Key points:**
1. Logistic regression for binary outcomes (ignores time)
2. Cox regression for time-to-event (preferred for cohort studies)
3. Always check model assumptions
4. Interpret in clinical context, not just statistical significance

**Logistic Regression Teaching Points:**
- Odds ratio interpretation: "For each unit increase in X, the odds of Y change by..."
- Emphasize that OR ≈ RR only when outcome is rare (<10%)
- Show the difference between crude and adjusted estimates

**Cox Regression Teaching Points:**
- Hazard ratio = rate ratio (instantaneous risk at any given time)
- Kaplan-Meier curves visualize survival differences
- **Critical:** Check proportional hazards assumption with `cox.zph()`
- Explain censoring: "We don't know when they would have had the event, just that they didn't during follow-up"

**Interpretation Tips:**
- HR of 0.7 means "30% lower rate of events"
- Always frame in clinical terms: "Participants who exercised regularly had a 30% lower rate of heart attacks..."
- Discuss both statistical significance (p-value, CI) AND clinical significance (effect size)

**Common Student Mistakes:**
1. Forgetting to check PH assumption
2. Confusing OR and HR ("they're both ratios, right?")
3. Not considering confounding by indication (e.g., statin users are sicker)
4. Over-interpreting non-significant results ("no association" vs "we didn't detect an association")

**Exercise 6 Discussion:**
- Statin analysis illustrates confounding by indication
- Even after adjustment, observational studies of medications are challenging
- This is why we need RCTs for causal claims about treatments

---

## Data Quality Issues Cheat Sheet

These are intentionally planted issues for students to find:

| Issue | Location | How to Find | Solution |
|-------|----------|-------------|----------|
| Duplicate IDs | P0001, P0002 | `count(patient_id) %>% filter(n>1)` | Keep first or investigate |
| Age = 150, -5, 999 | Rows 15, 234, 567 | `summary(age)` or validation | Set to NA |
| SBP = 350, 40 | Rows 89, 456 | Range check | Set to NA |
| BMI = 5, 75 | Rows 123, 789 | Range check | Set to NA |
| Future dates | Rows 100, 200 | Date validation | Set to NA |
| Mixed sex coding | Throughout | `unique(sex)` | Standardize |
| Mixed case in categorical | Throughout | `unique()` | tolower/case_when |
| Yes/No vs 0/1 | diabetes, hypertension | `unique()` | Recode to consistent |

---

## Backup Plans

### If R doesn't work for some students:
1. Pair programming with neighbor
2. Follow along with rendered HTML
3. Focus on concepts, they can practice code later

### If running behind schedule:
1. Skip Exercise 4 (can be homework)
2. Condense missing data section (focus on visualization, brief MICE demo)
3. Move some "preview analysis" content to "further reading"

### If ahead of schedule:
1. Deeper discussion on DAGs and causal inference
2. More time for Q&A
3. Start working on participants' own datasets

---

## Post-Workshop

### Share with participants:
1. R Markdown file
2. Rendered HTML
3. Dataset generation script
4. This instructor guide (optional, some find it useful)

### Suggested follow-up resources:
- R for Data Science (free online)
- van Buuren's FIMD book for missing data
- Hernán & Robins' Causal Inference book for DAGs

---

## Notes for Future Iterations

*Space to add notes after teaching:*

- What worked well:
- What needs more time:
- Common questions to address:
- Suggested modifications:

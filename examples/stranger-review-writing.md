# Example: Stranger Review Loop on writing

**Prompt (same in both runs):**
"Write a short LinkedIn post announcing that our app now works offline."

---

## Without the loop (raw one-shot answer)

> 🚀 Big news! We're thrilled to announce that our app now works offline!
> In today's fast-paced world, connectivity isn't always guaranteed. That's
> why our team has been working tirelessly to bring you a seamless offline
> experience. Whether you're on a plane, in the subway, or off the grid,
> you can now access all your data anytime, anywhere. This is a game-changer
> for productivity. Try it today and let us know what you think! #offline
> #productivity #innovation

Generic, claim-inflated, and buries the one thing users care about.

---

## With the loop

**Reframe:** draft submitted by an unknown junior writer to a demanding
editor. Critique against fixed dimensions:

1. **Unsupported claim:** "access all your data" — offline mode almost never
   covers *all* data. If sync-pending items aren't available, this line
   generates support tickets. Needs precision.
2. **Buried lede:** the actual user benefit (keep working with no signal)
   arrives in sentence four, after filler about "today's fast-paced world."
3. **Redundancy / filler:** "thrilled to announce," "working tirelessly,"
   "game-changer" — three clichés carrying zero information.
4. **Missing concrete detail:** what actually works offline? Reading?
   Editing? Does it sync back automatically? The post gives a reader nothing
   to evaluate.

**Revision fixing only the named problems:**

> Your notes now work without internet.
>
> Open the app on a plane, in the subway, anywhere — read and edit
> everything you've already synced. Your changes upload automatically the
> next time you're online.
>
> One honest limitation: files shared with you while you're offline appear
> after you reconnect.
>
> Rolling out to everyone this week. No settings to change — it just works.

---

## The point

Pass 1 would have shipped. The persona shift matters because models defend
their own drafts; the same model tearing into "someone else's" draft found
four concrete problems in seconds — including a claim ("all your data") that
was quietly false. That's the self-correction blind spot being used as a
tool instead of suffered as a bug.

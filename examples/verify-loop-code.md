# Example: Verify Loop on a coding task

**Prompt (same in both runs):**
"Write a Python function that returns the median of a list of numbers."

---

## Without the loop (raw one-shot answer)

```python
def median(nums):
    nums.sort()
    n = len(nums)
    if n % 2 == 1:
        return nums[n // 2]
    return (nums[n // 2] + nums[n // 2 - 1]) / 2
```

Looks fine. Ships with two real bugs.

---

## With the Verify Loop

**Step 1 — checks derived before answering:**

1. `median([1, 3, 2])` → `2` (odd length)
2. `median([1, 2, 3, 4])` → `2.5` (even length)
3. `median([])` → should raise a clear error, not crash cryptically
4. `median([5])` → `5`
5. Calling `median(nums)` must NOT modify the caller's list
   (`nums.sort()` mutates in place — a classic silent bug)

**Step 2 — generate. Step 3 — run checks:**

- Checks 1, 2, 4: pass
- Check 3: **fail** — `IndexError: list index out of range`, cryptic
- Check 5: **fail** — caller's list is silently reordered

**Step 4 — fix only the failures:**

```python
def median(nums):
    if not nums:
        raise ValueError("median() requires at least one number")
    s = sorted(nums)          # sorted() copies; caller's list untouched
    n = len(s)
    if n % 2 == 1:
        return s[n // 2]
    return (s[n // 2] + s[n // 2 - 1]) / 2
```

All 5 checks pass.

---

## The point

The one-shot answer was *plausible* — it passes the happy path and any casual
read. The loop didn't make the AI "think harder"; it forced the answer to
face checks written **before** the answer existed. Check 5 (mutation) is
exactly the kind of bug that "double-check your code" almost never catches,
because the code looks correct.

Cost: a few seconds. Caught: a crash and a data-corruption bug.

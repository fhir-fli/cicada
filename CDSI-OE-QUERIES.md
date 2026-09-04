# ONE ITEM OPEN

Paste everything below the line into OpenEvidence. Nothing else here is open.

Rulings on everything already adjudicated are kept separately and are not to be
pasted again.

---

## Tdap in pregnancy is gated on recorded sex as well as on pregnancy

CDSi 4.65-508 defines a "Pertussis risk 1-dose series" with two conditions on
it at once:

* `requiredGender`: **Female** and **Unknown**
* an indication on observation **007, Pregnant**, whose own text reads
  *"Administer to women who are pregnant."*

An engine applies both, so a pregnant patient whose record carries
`Patient.gender = male` satisfies the indication and is excluded by the gender
gate. They receive no Tdap risk recommendation. Recorded as `other`, `unknown`,
or with the element absent, they receive it, because CDC lists Unknown beside
Female.

`Patient.gender` is bound required in FHIR R4 to male | female | other |
unknown and its own definition calls the element administrative. CDSi does not
say what its Gender attribute means: the glossary reads "Patient Gender: the
patient's gender".

**Our reading:** the pregnancy is what makes Tdap apply. The gender gate adds
no information on this series and can only exclude, and the patient it excludes
is one whose recorded sex does not match their anatomy. We have therefore made
pregnancy outrank the gender gate for this series only, and we would like that
checked.

**The questions:**

1. Is there any patient for whom the `requiredGender` on this series changes the
   right answer, given that observation 007 is already required?
2. Should a pregnant patient whose record says `male` receive Tdap?
3. If yes, is the defect in CDSi's supporting data, or is an engine expected to
   apply `requiredGender` strictly and leave this to a clinician override?

Of the eleven gender-gated series in 4.65-508 this is the only one whose
indication is the qualifying state itself. The other ten are HPV, gated on age
or immunocompromise, and exist as duplicated male and non-male pairs with
identical doses, ages and intervals.

---

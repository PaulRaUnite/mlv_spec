# MRTCCSL syntax

- `a <= b` means `a causes b`, `a < b` is `a precedes b` (difference is that causes allows same tick occurence)
- `delayed by` is real-time delay
- `a + b` (plus) means either of clocks
- `a - b` (minus) means `a` unless `b`
- `a +<= b` implies that b can be caused by `a`, but also by other clocks (usual causality is exclusive)
- `a += b` is an extensive sum, `a` can be extended in other specifications
- `mutex{a => b, c => d}` rewrites into call `mutex(a,b,c,d)`

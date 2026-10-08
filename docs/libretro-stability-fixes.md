# Libretro stability fixes

These changes address problems reproduced with Mercenaries on Windows.

- PGRAPH and GP/EP DSP reads now extract byte and halfword values from aligned
  registers. AC97 handles additional byte reads and returns all ones for
  unimplemented registers instead of aborting the emulator.
- Each save-state marker references a separate HDD snapshot UUID and identifies
  the game by the SHA-256 of its content path. Legacy markers and markers for a
  different game are rejected. Audio queued before a restore is discarded.
- Vulkan presentation holds the framebuffer lease while the frontend consumes
  the image, and initializes the layout again after importing a different image.
- Audio delivery drains short scheduling backlogs before discarding samples;
  sustained backlogs remain bounded.
- Shutdown pauses the virtual CPUs, drains outstanding block I/O and flushes the
  HDD before the emulation thread exits.

## Validation and limitations

The modified Windows DLL compiled successfully. Visible Vulkan/1x testing passed
more than two minutes with changing images. Two automatic close/reopen cycles
loaded different newly saved snapshot UUIDs; separate testing covered manual
restore, rejection of legacy markers and rejection of another game's marker.
The frontend's automatic-save policy is independent of these core changes.

An existing HDD cache caused a guest fault and frozen loading in both 1x and
10x. Repairing X/Y/Z caches on a copy restored progress while preserving system
and save partitions. These code changes do not repair already damaged caches.

State markers still require the same HDD containing their snapshots. Moving a
ROM changes its path identity. Snapshots are retained and may grow the HDD;
garbage collection is not implemented. Linux runtime validation and a guarantee
of full-speed rendering at high resolution are outside this validation.

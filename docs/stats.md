# hipify-perl Statistics

hipify-perl now provides standardized statistics aligned with hipify-clang:

- `total`: total CUDA occurrences encountered
- `converted`: successful CUDA API -> HIP API conversions
- `replaced`: textual replacements (macros, includes, etc.)
- `unsupported`: occurrences of unsupported APIs

## Stats Module

The `bin/stats.pm` module provides a standardized interface for tracking statistics:

```perl
use FindBin;
use lib "$FindBin::Bin";
require "stats.pm";

my $stats = hipify_stats::init_stats();

# During processing:
hipify_stats::inc_total($stats);
hipify_stats::inc_converted($stats);    # when a CUDA API maps cleanly
hipify_stats::inc_replaced($stats);     # textual/macro replacements
hipify_stats::inc_unsupported($stats);  # unsupported API occurrences

# After processing:
hipify_stats::emit_stats($stats, $stats_json);
```

## JSON Output

Enable JSON output with the `--stats-json` flag:

```bash
perl bin/hipify-perl myfile.cu --stats-json
```

This outputs statistics in machine-readable JSON format:

```json
{"converted":10,"replaced":5,"total":20,"unsupported":5}
```

## Integration Notes

To integrate this module into the existing hipify-perl script:

1. Add `use lib "$FindBin::Bin";` and `require "stats.pm";` near the top
2. Add `--stats-json` to the GetOptions section
3. Initialize stats with `my $stats = hipify_stats::init_stats();`
4. Update conversion logic to increment appropriate counters
5. Call `hipify_stats::emit_stats($stats, $stats_json);` at the end

The existing `--print-stats` flag continues to work with the current detailed statistics format. The new standardized stats provide a simpler, hipify-clang-compatible output format.

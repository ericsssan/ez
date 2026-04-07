const std = @import("std");
const parallel = @import("parallel.zig");
const FileResult = parallel.FileResult;

/// Formats and aggregates diagnostic output from parallel lint runs.
///
/// Provides two main operations:
///   - `formatResults`:  write all per-file diagnostic text to the output
///   - `formatSummary`:  write a final summary line with totals
pub const DiagnosticFormatter = struct {
    /// Write the diagnostic text from all file results to the given writer.
    ///
    /// Results should be pre-sorted (by `ParallelRunner.sortResults`) for
    /// deterministic output.  A blank line is inserted between files that
    /// both have diagnostics, matching the conventional linter output style.
    pub fn formatResults(results: []const FileResult, writer: anytype) !void {
        var prev_had_output = false;
        for (results) |result| {
            if (result.output.len == 0) continue;

            // Separate output between files with a blank line.
            if (prev_had_output) {
                try writer.writeAll("\n");
            }

            try writer.writeAll(result.output);
            prev_had_output = true;
        }
    }

    /// Write a summary line, e.g.:
    ///   "5 problems (3 errors, 2 warnings)"
    ///   (nothing if no problems)
    pub fn formatSummary(
        total_errors: u32,
        total_warnings: u32,
        total_files: u32,
        writer: anytype,
    ) !void {
        const total = total_errors + total_warnings;
        if (total == 0) {
            try writer.print(
                "\nez: no issues found in {d} file{s}\n",
                .{ total_files, if (total_files != 1) @as([]const u8, "s") else "" },
            );
            return;
        }

        try writer.print("\n{d} problem{s} ({d} error{s}, {d} warning{s})\n", .{
            total,
            if (total != 1) @as([]const u8, "s") else "",
            total_errors,
            if (total_errors != 1) @as([]const u8, "s") else "",
            total_warnings,
            if (total_warnings != 1) @as([]const u8, "s") else "",
        });
    }

    /// Returns `true` if any result contains errors — useful for setting
    /// the process exit code.
    pub fn hasErrors(results: []const FileResult) bool {
        for (results) |result| {
            if (result.error_count > 0) return true;
        }
        return false;
    }

    /// Returns `true` if any result contains diagnostics of any severity.
    pub fn hasDiagnostics(results: []const FileResult) bool {
        for (results) |result| {
            if (result.error_count > 0 or result.warning_count > 0) return true;
        }
        return false;
    }
};

//! Type checker — minimal TS-flavored type inference and assignability
//! sufficient for the `no-unsafe-*` family of typescript-eslint rules.
//!
//! Not a full TS implementation: we lean on annotations, do not perform
//! generic inference, and treat unresolved references as `any` (with
//! `containsAny` reporting so rules still fire on the most common
//! `JSON.parse(...)`-like patterns).

pub const types = @import("types.zig");
pub const Checker = @import("checker.zig").Checker;
pub const ModuleCache = @import("module_cache.zig").ModuleCache;

test {
    _ = types;
    _ = @import("checker.zig");
}

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Optional custom build option, e.g., override binary name
    const exe_name = b.option([]const u8, "exe_name", "Executable name") orelse "json_parser";

    // Build executable
    const exe = b.addExecutable(.{
        .name = exe_name,
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    // Add a "run" command
    const run = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run.step);
    if (b.args) |args| run.addArgs(args);

    // Build and run tests
    const unit_tests = b.addTest(.{
        .root_source_file = b.path("tests/test.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}

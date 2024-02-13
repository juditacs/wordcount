// SPDX-License-Identifier: MIT
// Copyright (c) 2024 Michael Ortmann

const std = @import("std");

const Entry = struct { key_ptr: *[]const u8, value: u32 };

fn cmp(context: void, a: Entry, b: Entry) bool {
    _ = context;

    if (a.value < b.value)
        return false;

    if (a.value > b.value)
        return true;

    return std.mem.lessThan(u8, a.key_ptr.*, b.key_ptr.*);
}

pub fn main() !void {
    var buffered_reader = std.io.bufferedReader(std.io.getStdIn().reader());
    const allocator = std.heap.page_allocator;
    const buf = try buffered_reader.reader().readAllAlloc(allocator, 8 * 1024 * 1024 * 1024);
    var tokens = std.mem.tokenizeAny(u8, buf, " \t\n");
    var map = std.StringHashMap(u32).init(allocator);

    while (tokens.next()) |word| {
        if (map.getPtr(word)) |ptr| {
            ptr.* += 1;
        } else try map.put(word, 1);
    }

    var it = map.iterator();
    var a = try allocator.alloc(Entry, map.count());
    var i: u32 = 0;

    while (it.next()) |kv| {
        a[i] = Entry{ .key_ptr = kv.key_ptr, .value = (kv.value_ptr.* << 7) | ((kv.key_ptr.*[0] >> 1) ^ 0x7f) };
        i += 1;
    }

    std.mem.sortUnstable(Entry, a, {}, comptime cmp);
    var buffered_writer = std.io.bufferedWriter(std.io.getStdOut().writer());

    for (a) |e| {
        try buffered_writer.writer().print("{s}\t{any}\n", .{ e.key_ptr.*, e.value >> 7 });
    }

    try buffered_writer.flush();
}

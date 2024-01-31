#!/usr/bin/env -S rust-script -t nightly
#![feature(unix_sigpipe)]

use std::cmp::max;

const BASIC_COLORS: &[&str] = &[
    "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white",
];

fn title(t: &str) {
    println!("{}\n{: <2$}", t, "", t.len())
}

fn reset() {
    print!("\x1B[m");
}

fn sgr(p: u32) {
    print!("\x1B[{}m", p);
}

fn color_table_with_offset(fg_offset: usize, bg_offset: usize) {
    for (bg, _) in BASIC_COLORS.iter().enumerate() {
        print!("\x1B[{}m", bg_offset + bg);
        for (fg, fg_name) in BASIC_COLORS.iter().enumerate() {
            print!("\x1B[{}m", fg_offset + fg);
            print!(" {} ", fg_name);
        }
        println!("\x1B[39;49m");
    }
}

fn basic_color_table() {
    color_table_with_offset(30, 40)
}

fn aix_bright_color_table() {
    color_table_with_offset(90, 100)
}

fn fg_index_legacy(i: u32) {
    print!("\x1B[38;5;{}m", i);
}
fn bg_index_legacy(i: u32) {
    print!("\x1B[48;5;{}m", i);
}
fn fg_index_standard(i: u32) {
    print!("\x1B[38:5:{}m", i);
}
fn bg_index_standard(i: u32) {
    print!("\x1B[48:5:{}m", i);
}
fn fg_rgb_legacy(r: u8, g: u8, b: u8) {
    print!("\x1B[38;2;{};{};{}m", r, g, b);
}
fn bg_rgb_legacy(r: u8, g: u8, b: u8) {
    print!("\x1B[48;2;{};{};{}m", r, g, b);
}
fn fg_rgb_standard(r: u8, g: u8, b: u8) {
    print!("\x1B[38:2::{}:{}:{}m", r, g, b);
}
fn bg_rgb_standard(r: u8, g: u8, b: u8) {
    print!("\x1B[48:2::{}:{}:{}m", r, g, b);
}
fn reset_fgbg() {
    println!("\x1B[39;49m");
}

fn color_cube(fg_index: fn(u32), bg_index: fn(u32)) {
    for i in 0..16 {
        fg_index(16 - i - 1);
        bg_index(i);
        print!("x");
    }
    reset_fgbg();
    for i in 0..6 {
        for j in 0..36 {
            fg_index(16 + 36 * i + j);
            bg_index(16 + 216 - (36 * i + j) - 1);
            print!("x");
        }
        reset_fgbg();
    }
    for i in 232..256 {
        fg_index(232 + 256 - i - 1);
        bg_index(i);
        print!("x");
    }
    reset_fgbg();
}

fn legacy_color_cube() {
    color_cube(fg_index_legacy, bg_index_legacy);
}

fn standard_color_cube() {
    color_cube(fg_index_standard, bg_index_standard);
}

fn rgb(fg_rgb: fn(u8, u8, u8), bg_rgb: fn(u8, u8, u8)) {
    const V: [u8; 17] = [
        0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 255,
    ];

    for i in 0..17 {
        for j in 0..17 {
            let r = 255 - V[max(i, j)];
            let g = V[j];
            let b = V[i];
            fg_rgb(255 - r, 255 - g, 255 - b);
            bg_rgb(r, g, b);
            print!(" x ");
        }
        reset_fgbg();
    }
}

fn legacy_rgb() {
    rgb(fg_rgb_legacy, bg_rgb_legacy);
}

fn standard_rgb() {
    rgb(fg_rgb_standard, bg_rgb_standard);
}

fn other_character_functions() {
    fn reset_sgr(p: u32) {
        print!("\x1B[;{}m", p);
    }
    // https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h4-Functions-using-CSI-_-ordered-by-the-final-character-lparen-s-rparen:CSI-Pm-m.1CA7
    // T-REC-T.416-199303-I!!PDF-E.pdf
    // https://www.ecma-international.org/wp-content/uploads/ECMA-48_5th_edition_june_1991.pdf
    const CODES: &[(u32, &str)] = &[
        (0, "plain"),
        (1, "bold"),
        (2, "faint"),
        (3, "italic"),
        (4, "underline"),
        (5, "slow blink"),
        (6, "fast blink"),
        (7, "reverse"),
        (8, "conceal"),
        (9, "crossed out"),
        (21, "double underline?"),
        (51, "framed"),
        (52, "encircled"),
        (53, "overlined"),
        // Ideogram parameters:
    ];
    let mut i = 0;
    for (code, name) in CODES {
        if i >= 8 {
            println!();
            i = 0;
        }
        i += 1;

        print!("{}: ", code);
        reset_sgr(*code);
        print!("{}", name);
        sgr(0);
        print!("  ");
    }
    println!();
}

#[unix_sigpipe = "inherit"]
fn main() {
    title("ANSI basic colors");

    basic_color_table();
    reset();

    println!();
    title("ANSI bold/bright basic colors");
    print!("\x1B[{}m", 1);
    basic_color_table();
    reset();

    println!();
    title("AIX (nonstandard) bright colors");
    aix_bright_color_table();
    reset();

    println!();
    title("256-color palette (legacy semicolon syntax)");
    legacy_color_cube();
    reset();

    println!();
    title("256-color palette (standard colon syntax)");
    standard_color_cube();
    reset();

    println!();
    title("24-bit RGB (legacy semicolon syntax)");
    legacy_rgb();
    reset();

    println!();
    title("24-bit RGB (standard colon syntax)");
    standard_rgb();
    reset();

    println!();
    title("Other character functions");
    other_character_functions();
    reset();
}

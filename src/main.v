module main

import os
import arrays
import math
import lemoncmd.mecab as _ {MeCab}

fn main() {
	if os.args.len == 1 {
		panic('usage: ./gomamayo [string to parse] ...')
	}

	m := MeCab.new()!
	for input in os.args[1..] {
		parsed := m.parse_str_tostr(input)!.split('\n')#[..-2]
		pronounces := parsed.map(it.split(',').last()).map(fn (s string) []string {
			runes := s.runes().reverse()
			mut ss := []string{}
			mut small := ?rune(none)
			for r in runes {
				if r in [`ャ`,`ュ`,`ョ`,`ァ`,`ィ`,`ゥ`,`ェ`,`ォ`] {
					small = r
				} else if sm := small {
					ss << r.str() + sm.str()
					small = none
				} else {
					ss << r.str()
				}
			}
			return ss.reverse()
		})
		mut max_order := 0
		mut terms := 0
		for pronounce_pair in arrays.window(pronounces, size: 2) {
			mut order := 0
			for i in 1..math.min(pronounce_pair[0].len, pronounce_pair[1].len) {
				if pronounce_pair[0]#[-i..] == pronounce_pair[1][..i] {
					order = i
				}
			}
			if order > 0 {
				terms++
				max_order = math.max(max_order, order)
			}
		}
		if terms == 0 {
			println('ゴママヨではありません')
		} else {
			println('${input}: ${terms}項${max_order}次のゴママヨです')
		}
	}
}

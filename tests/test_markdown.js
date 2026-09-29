// web/markdown.js 的回归测试（纯 node，不需要浏览器）。
//
//     node tests/test_markdown.js
//
// 重点不是「排版好不好看」，而是两件事：
//   1) 常见结构都渲染出来了（标题/列表/表格/代码块/引用/链接）；
//   2) **不会被模型输出里的 HTML 与 javascript: 链接带跑**。
const fs = require('fs');
const path = require('path');

global.window = {};
require(path.join(__dirname, '..', 'web', 'markdown.js'));
const md = global.window.renderMarkdown;

let failed = 0;
function check(name, cond, extra) {
  if (cond) {
    console.log('  ok   ' + name);
  } else {
    failed++;
    console.log('  FAIL ' + name + (extra ? '  → ' + extra : ''));
  }
}

const src = [
  '# 标题',
  '',
  '正文 **粗体** 与 `代码`。',
  '',
  '- 项目一',
  '- 项目二',
  '',
  '1. 第一',
  '2. 第二',
  '',
  '- [x] 完成',
  '- [ ] 未完成',
  '',
  '| A | B |',
  '|:--|--:|',
  '| 1 | 2 |',
  '',
  '> 引用',
  '',
  '```bash',
  'echo "<x>&y"',
  '```',
  '',
  '[链接](https://example.com/) 与 https://bare.test/p',
].join('\n');

const html = md(src);
check('标题', html.includes('<h1>标题</h1>'));
check('粗体', html.includes('<strong>粗体</strong>'));
check('行内代码', html.includes('<code>代码</code>'));
check('无序列表', html.includes('<ul><li>项目一</li>'));
check('有序列表', html.includes('<ol><li>第一</li>'));
check('任务列表', html.includes('<input type="checkbox" disabled checked>'));
check('表格', html.includes('<table>') && html.includes('<th style="text-align:right">B</th>'));
check('引用', html.includes('<blockquote>引用</blockquote>'));
check('代码块带语言', html.includes('data-lang="bash"'));
check('代码块内容被转义', html.includes('echo &quot;&lt;x&gt;&amp;y&quot;'));
check('链接', html.includes('href="https://example.com/"'));
check('裸链接', html.includes('href="https://bare.test/p"'));

// 安全：脚本标签必须只是文本，javascript: 链接不能被放行
const evil = md('<script>alert(1)</script>\n\n[点我](javascript:alert(1))\n\n<img src=x onerror=alert(1)>');
check('script 被转义', evil.includes('&lt;script&gt;') && !evil.includes('<script>'));
check('javascript: 被拦', !evil.includes('javascript:alert'));
check('img onerror 被转义', !evil.includes('<img src=x'));

// 未闭合的代码块也要收尾
check('未闭合代码块', md('```\nabc').includes('<div class="codeblock">'));

console.log(failed ? `markdown FAIL（${failed} 项）` : 'markdown ok');
process.exit(failed ? 1 : 0);

// web/markdown.js —— 轻量 Markdown 渲染器：零依赖、纯前端、离线可用。
//
// 覆盖实际会遇到的子集：ATX 标题、粗体/斜体/删除线、行内代码、围栏代码块
// （带语言标注与复制按钮）、无序/有序/任务列表、引用、水平线、链接与裸链接、
// 管道表格、图片。
//
// 安全：先把文本整体 HTML 转义再拼 HTML；链接只放行 http/https/mailto 与相对地址，
// 其余一律降级成 '#'，所以模型输出里的 <script> 之类不会被当成标签执行。
(function () {
  'use strict';

  var ESC = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' };

  function esc(value) {
    return String(value == null ? '' : value).replace(/[&<>"']/g, function (c) { return ESC[c]; });
  }

  function safeUrl(raw) {
    var url = String(raw == null ? '' : raw).trim();
    if (/^(https?:|mailto:|#|\/|\.\/|\.\.\/)/i.test(url)) return url;
    return '#';
  }

  function attr(url) {
    return esc(safeUrl(url)).replace(/"/g, '&quot;');
  }

  // 行内元素。先把 `code` 抠出来占位，其余按顺序替换，最后再还原。
  function inline(src) {
    var codes = [];
    var s = String(src == null ? '' : src).replace(/`([^`]+)`/g, function (m, code) {
      codes.push(code);
      return '\u0000' + (codes.length - 1) + '\u0000';
    });
    s = esc(s);
    s = s.replace(/!\[([^\]]*)\]\(([^)\s]+)\)/g, function (m, alt, url) {
      return '<img src="' + attr(url.replace(/&amp;/g, '&')) + '" alt="' + alt + '" loading="lazy">';
    });
    s = s.replace(/\[([^\]]*)\]\(([^)\s]+)\)/g, function (m, label, url) {
      return '<a href="' + attr(url.replace(/&amp;/g, '&')) +
             '" target="_blank" rel="noreferrer noopener">' + label + '</a>';
    });
    s = s.replace(/(^|[\s(（])(https?:\/\/[^\s<)）]+)/g, function (m, pre, url) {
      return pre + '<a href="' + attr(url) +
             '" target="_blank" rel="noreferrer noopener">' + url + '</a>';
    });
    s = s.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
    s = s.replace(/__([^_]+)__/g, '<strong>$1</strong>');
    s = s.replace(/(^|[^*\w])\*([^*\n]+)\*/g, '$1<em>$2</em>');
    s = s.replace(/~~([^~]+)~~/g, '<del>$1</del>');
    s = s.replace(/\u0000(\d+)\u0000/g, function (m, i) {
      return '<code>' + esc(codes[+i]) + '</code>';
    });
    return s;
  }

  function codeBlock(code, lang) {
    return '<div class="codeblock"><button class="copy" type="button">复制</button>' +
           '<pre><code data-lang="' + esc(lang || '') + '">' + esc(code) + '</code></pre></div>';
  }

  function cells(line) {
    return line.replace(/^\s*\|/, '').replace(/\|\s*$/, '').split('|')
               .map(function (c) { return c.trim(); });
  }

  function alignOf(cell) {
    if (/^:-+:$/.test(cell)) return 'center';
    if (/-+:$/.test(cell)) return 'right';
    if (/^:-+/.test(cell)) return 'left';
    return '';
  }

  function render(source) {
    var lines = String(source == null ? '' : source).replace(/\r\n?/g, '\n').split('\n');
    var html = '', inCode = false, lang = '', buf = [], list = null;
    var closeList = function () {
      if (list) { html += list === 'ul' ? '</ul>' : '</ol>'; list = null; }
    };

    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      var m = line.match(/^\s*```+\s*([\w+#.:-]*)\s*$/);
      if (m) {
        if (!inCode) { closeList(); inCode = true; lang = m[1] || ''; buf = []; }
        else { html += codeBlock(buf.join('\n'), lang); inCode = false; }
        continue;
      }
      if (inCode) { buf.push(line); continue; }
      if (!line.trim()) { closeList(); continue; }

      if ((m = line.match(/^(#{1,6})\s+(.*)$/))) {
        closeList();
        var lv = Math.min(m[1].length, 4);
        html += '<h' + lv + '>' + inline(m[2].replace(/\s+#+\s*$/, '')) + '</h' + lv + '>';
        continue;
      }
      if (/^\s*([-*_])(\s*\1){2,}\s*$/.test(line)) { closeList(); html += '<hr>'; continue; }

      // 管道表格：本行含 |，且下一行是分隔行
      if (line.indexOf('|') >= 0 && i + 1 < lines.length &&
          lines[i + 1].indexOf('-') >= 0 &&
          /^\s*\|?[\s:|-]+\|[\s:|-]*$/.test(lines[i + 1])) {
        closeList();
        var head = cells(line);
        var aligns = cells(lines[i + 1]).map(alignOf);
        var body = '';
        i += 2;
        for (; i < lines.length; i++) {
          if (!lines[i].trim() || lines[i].indexOf('|') < 0) break;
          var rowCells = cells(lines[i]);
          body += '<tr>' + head.map(function (_, k) {
            return '<td' + (aligns[k] ? ' style="text-align:' + aligns[k] + '"' : '') + '>' +
                   inline(rowCells[k] || '') + '</td>';
          }).join('') + '</tr>';
        }
        i--;
        html += '<div class="tablewrap"><table><thead><tr>' + head.map(function (h, k) {
          return '<th' + (aligns[k] ? ' style="text-align:' + aligns[k] + '"' : '') + '>' +
                 inline(h) + '</th>';
        }).join('') + '</tr></thead><tbody>' + body + '</tbody></table></div>';
        continue;
      }

      if ((m = line.match(/^\s*[-*+]\s+\[([ xX])\]\s+(.*)$/))) {
        if (list !== 'ul') { closeList(); html += '<ul class="tasklist">'; list = 'ul'; }
        html += '<li class="task"><input type="checkbox" disabled' +
                (m[1].toLowerCase() === 'x' ? ' checked' : '') + '>' + inline(m[2]) + '</li>';
        continue;
      }
      if ((m = line.match(/^\s*[-*+]\s+(.*)$/))) {
        if (list !== 'ul') { closeList(); html += '<ul>'; list = 'ul'; }
        html += '<li>' + inline(m[1]) + '</li>';
        continue;
      }
      if ((m = line.match(/^\s*\d+[.)]\s+(.*)$/))) {
        if (list !== 'ol') { closeList(); html += '<ol>'; list = 'ol'; }
        html += '<li>' + inline(m[1]) + '</li>';
        continue;
      }
      if ((m = line.match(/^\s*>\s?(.*)$/))) {
        closeList();
        html += '<blockquote>' + inline(m[1]) + '</blockquote>';
        continue;
      }
      closeList();
      html += '<p>' + inline(line) + '</p>';
    }
    if (inCode) html += codeBlock(buf.join('\n'), lang);
    closeList();
    return html;
  }

  window.renderMarkdown = render;
  window.renderMarkdownInline = inline;
})();

local p = {}
-- 通用
local getArgs = require('Module:Arguments').getArgs
local raid_DB = require('Module:Util/QuestDB')

---------------------------------------------------------------------------
-- 生成副本掉落表格
---------------------------------------------------------------------------

function p.main(frame)
  local args = getArgs(frame)
  local pagename = args.pagename

  -- SMW数据
  local red_Host, red_MVP, gold, silver, wooden, blue, purple, green, deal = p.smw_set_subobject(args, pagename)

  -- 页面展示
  local html = mw.html.create('div')

  -- 数据表格
  local table = html:tag('table'):addClass('wikitable ec w-full mw-collapsible mw-collapsed')
  local table_head = table:tag('tr')
  local table_body = table:tag('tr')

  if red_Host then
    table_head:tag('th'):wikitext('[[File:Icon_Red_Chest.png|link=|25px]] 自发红箱'):done()
    table_body:tag('td'):addClass('text-center align-top')
        :tag('div'):addClass('inline-block text-left'):wikitext(frame:preprocess('{{itemlist|' ..
    red_Host .. '|显示数字=no}}'))
        :done()
  end
  if red_MVP then
    table_head:tag('th'):wikitext('[[File:Icon_Red_Chest.png|link=|25px]] 顺位红箱'):done()
    table_body:tag('td'):addClass('text-center align-top')
        :tag('div'):addClass('inline-block text-left'):wikitext(frame:preprocess('{{itemlist|' .. red_MVP .. '|显示数字=no}}'))
        :done()
  end
  if gold then
    table_head:tag('th'):wikitext('[[File:Icon_Gold_Chest.png|link=|25px]] 金箱'):done()
    table_body:tag('td'):addClass('text-center align-top')
        :tag('div'):addClass('inline-block text-left'):wikitext(frame:preprocess('{{itemlist|' .. gold .. '|显示数字=no}}'))
        :done()
  end
  if silver then
    table_head:tag('th'):wikitext('[[File:Icon_Silver_chest.png|link=|25px]] 银箱'):done()
    table_body:tag('td'):addClass('text-center align-top')
        :tag('div'):addClass('inline-block text-left'):wikitext(frame:preprocess('{{itemlist|' .. silver .. '|显示数字=no}}'))
        :done()
  end
  if wooden then
    table_head:tag('th'):wikitext('[[File:Icon_Wood_chest.png|link=|25px]] 木箱'):done()
    table_body:tag('td'):addClass('text-center align-top')
        :tag('div'):addClass('inline-block text-left'):wikitext(frame:preprocess('{{itemlist|' .. wooden .. '|显示数字=no}}'))
        :done()
  end
  if blue then
    table_head:tag('th'):wikitext('[[File:Icon_Blue_chest.png|link=|25px]] 蓝箱'):done()
    table_body:tag('td'):addClass('text-center align-top')
        :tag('div'):addClass('inline-block text-left'):wikitext(frame:preprocess('{{itemlist|' .. blue .. '|显示数字=no}}'))
        :done()
  end
  if purple then
    table_head:tag('th'):wikitext('[[File:Icon_Purple_Chest.png|link=|25px]] 紫箱'):done()
    table_body:tag('td'):addClass('text-center align-top')
        :tag('div'):addClass('inline-block text-left'):wikitext(frame:preprocess('{{itemlist|' .. purple .. '|显示数字=no}}'))
        :done()
  end
  if green then
    table_head:tag('th'):wikitext('[[File:Icon_Turquoise_Chest.png|link=|25px]] 绿箱'):done()
    table_body:tag('td'):addClass('text-center align-top')
        :tag('div'):addClass('inline-block text-left'):wikitext(frame:preprocess('{{itemlist|' .. green .. '|显示数字=no}}'))
        :done()
  end
  if deal then
    table_head:tag('th'):wikitext('[[File:团箱.png|link=|25px]] 团箱'):done()
    table_body:tag('td'):addClass('text-center align-top')
        :tag('div'):addClass('inline-block text-left'):wikitext(frame:preprocess('{{itemlist|' .. deal .. '|显示数字=no}}'))
        :done()
  end

  return html
end

---------------------------------------------------------------------------
-- SMW数据处理
---------------------------------------------------------------------------

function p.smw_set_subobject(args, pagename)
  local name_temp = mw.text.split(pagename, '/')[2]
  local raid_name = string.gsub(name_temp, '_', ' ') -- 下划线 转 空格
  local raid_id = p.inRaidDB(raid_name) or ''

  local red_Host = args.red_Host
  local red_MVP = args.red_MVP
  local gold = args.gold
  local silver = args.silver
  local wooden = args.wooden
  local blue = args.blue
  local purple = args.purple
  local green = args.green
  local deal = args.deal

  -- SMW数据
  local smw_args = {
    ['raidID'] = raid_id,
    ['自发红箱'] = red_Host,
    ['顺位红箱'] = red_MVP,
    ['金箱'] = gold,
    ['银箱'] = silver,
    ['木箱'] = wooden,
    ['蓝箱'] = blue,
    ['紫箱'] = purple,
    ['绿箱'] = green,
    ['团箱'] = deal,
    ['获取类型'] = '副本掉落',
  }

  -- 保存SMW数据
  mw.smw.subobject(smw_args)

  return red_Host, red_MVP, gold, silver, wooden, blue, purple, green, deal
end

-- 匹配副本ID
function p.inRaidDB(raid_name)
  for raid_id, raid in pairs(raid_DB) do
    if raid['title_chs'] == raid_name then
      return raid_id
    end
  end
end

return p

local p = {}
-- 通用
local getArgs = require('Module:Arguments').getArgs
local nickname_List = require('Module:Util/LinkNickname')

---------------------------------------------------------------------------
-- 生成列表
---------------------------------------------------------------------------

function p.main(frame)
  local args = getArgs(frame)
  local item_id = mw.text.split(args.pagename, '/')[2]
  local nickname = p.isNickname(item_id) or ''

  local outputHtml = mw.html.create()
  outputHtml:node(p.generateTable(args, item_id, nickname))

  return outputHtml
end

-- 俗语判断
function p.isNickname(item_id)
  for name, id in pairs(nickname_List) do
    if tostring(id) == item_id then
      return name
    end
  end
end

---------------------------------------------------------------------------
-- 读取SMW
---------------------------------------------------------------------------

function p.generateTable(args, item_id, nickname)
  local html = mw.html.create()
  local list = html:tag('ul')

  if args[1] == '讨伐' then
    --SMW读取
    local tab = mw.smw.getQueryResult('[[获取类型::副本掉落]]|?RaidID|?自发红箱|?顺位红箱|?金箱|?银箱|?木箱|?蓝箱|?紫箱|?绿箱|?团箱')

    for key, _ in ipairs(tab["results"]) do
      local result = tab["results"][key]["printouts"]
      local raid_id = result['RaidID'][1] or ''

      local box_list_temp = { '自发红箱', '顺位红箱', '金箱', '银箱', '木箱', '蓝箱', '紫箱', '绿箱', '团箱' }
      for box, box_item in pairs(result) do
        local inBox = false

        if box ~= 'RaidID' then
          for _, itemlist in ipairs(box_item) do
            local list_temp = mw.text.split(itemlist, ',')
            for _, item_info in ipairs(list_temp) do
              if item_info == item_id or item_info == nickname then
                inBox = true
                break
              end
            end
          end

          if inBox then
            if box == '自发红箱' then
              box_list_temp[box] = '{{红箱}}{{cb|自发红箱}}'
            elseif box == '顺位红箱' then
              box_list_temp[box] = '{{红箱}}{{cb|顺位红箱}}'
            else
              box_list_temp[box] = '{{' .. box .. '}}'
            end
          end
        end
      end

      local box_list = ''
      for _, value in ipairs(box_list_temp) do
        if box_list_temp[value] then
          box_list = box_list .. ' ' .. box_list_temp[value]
        end
      end

      local frame = mw.getCurrentFrame()
      list:tag('li'):wikitext(frame:preprocess('{{raid|' .. raid_id .. '|m1}}的' .. box_list))
    end
  end

  return html
end

return p

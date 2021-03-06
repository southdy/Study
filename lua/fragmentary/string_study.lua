--2013-09-18
--[[
a = "hello, world!hello, li!"
p, q = print(string.find(a, "hello"))
while(p) do
	print(p, q)
	p, q = print(string.find(a, "hello"))
end
]]
--2
--[[
b = "test(char)"
print(b)
print(string.find(b, "%(.*%)"))
c = string.reverse(b)
print(c)
p1, p2 = string.find(c, "%).*%(")
d= string.sub(c, p2+1)
print(d)
print(string.reverse(d))
]]
--[[
szFamilyName = "sdf(Title)"
nPos1 = string.find(szFamilyName, "%(")
szFamilyName1 = string.sub(szFamilyName, 1, nPos1-1)
print(11, szFamilyName1)
]]

----------------------------------------
--20.3 captures
--[[
pair = "name = Anna"
local n1, n2, key, value = string.find(pair, "(%a+)%s*=%s*(%a+)")
print(n1, n2, key, value)
--
local szName = "a,b,c"
--迭代

function split(str,splitor)
	if(splitor==nil) then
		splitor=','
	end
	local strArray={}
	local strStart=1
	local splitorLen = string.len(splitor)
	local index=string.find(str,splitor,strStart,true)
	if(index==nil) then
		strArray[1]=str
		return strArray
	end
	local i=1
	while index do
		strArray[i]=string.sub(str,strStart,index-1)
		i=i+1
		strStart=index+splitorLen
		index = string.find(str,splitor,strStart,true)
	end
	strArray[i]=string.sub(str,strStart,string.len(str))
	return strArray
end

local tbData = split(szName)
for k, v in pairs(tbData) do
	print(k, v)
end
]]

------------------------------
local szTest = "A"
--print(string.len(szTest))
--kmp
function kmp_next(szMode)
	local tbNext = {}
	szMode = tostring(szMode)
	tbNext[1] = 0;
	for j=2, string.len(szMode) do
		local i = tbNext[j-1];
		while szMode[j] ~= szMode[i+1] and i >= 1 do
			i = tbNext[i]
		end
		if szMode[j] == szMode[i+1] then
			tbNext[j] = i + 1
		else
			tbNext[j] = 0;
		end
	end
	return tbNext
end

function get_next(szMode)
	--print(szMode)
	local tbNext = {}
	szMode = tostring(szMode)
	local len = string.len(szMode)
	tbNext[1] = 0;
	local i = 1;
	local k = 0;
	--print("len", len)
	while i < len do
		--print("k, i", k, i, szMode[i], szMode[k])
		local szI = string.sub(szMode, i, i)
		local szK = string.sub(szMode, k, k)
		--print("szI, szK", szI, szK)
		
		if k == 0 or szI == szK then
			k = k + 1;
			i = i + 1;
			local szI = string.sub(szMode, i, i)
			local szK = string.sub(szMode, k, k)
		
			if szI ~= szK then
				tbNext[i] = k
			else
				tbNext[i] = tbNext[k];
			end
		else			
			k = tbNext[k];
		end
	end
	return tbNext
end

function kmp1(szDst, szMode)
	local tbNext = get_next(szMode)
	if #tbNext <= 0 then return; end
	
	local p = 1
	local s = 1
	while p <= string.len(szMode) and s <= string.len(szDst) do
		local cDst = string.sub(szDst, p, p)
		local cMod = string.sub(szMode, s, s)
		if cDst == cMod then
			p = p + 1;
			s = s + 1;
		else
			if p == 1 then
				s = s + 1;
			else
				p = tbNext[p-1] + 1;
			end
		end
	end
	
	if p < string.len(szMode) then
		return -1;
	end
	return s - string.len(szMode)
end

function kmp(szDst, szMode)
	local tbNext = get_next(szMode)
	if #tbNext <= 0 then return; end
	
	local p = 1
	local s = 1
	while p <= string.len(szMode) and s <= string.len(szDst) do
		local cDst = string.sub(szDst, p, p)
		local cMod = string.sub(szMode, s, s)
		if cDst == cMod then
			p = p + 1;
			s = s + 1;
		else
			p = tbNext[p];
		end
	end
	
	if p == string.len(szMode) then
		return s - p;
	end
	return -1;
end

function kmp_ex(szDst, szMode)
	--print(szDst, szMode)

	local lenDst = string.len(szDst)
	local lenMod = string.len(szMode)

	--if lenDst ~= lenMod then return -2; end
	local tbNext = get_next(szMode)

	if #tbNext <= 0 then return -2; end
	
	local p = 1
	local s = 1
	while p <= string.len(szMode) and s <= string.len(szDst) do
		local cDst = string.sub(szDst, p, p)
		local cMod = string.sub(szMode, s, s)
		--print("cDst, cMod", cDst, cMod)
		if cDst == cMod then
			p = p + 1;
			s = s + 1;
		else
			--if tbNext[p] == 0 then
				--return tbNext[p] + 1
			--else
				return s, tbNext[p];
			--end
		end
	end
	--print(p, s)
	--if p == string.len(szMode) then
	--	return -1;
	--end
	return -1;
end

--local tbNext = get_next("abcabaa")
--local tbNext = get_next("abcaabbabcabaacbacba")
--local tbNext = get_next("aaaadd")
--for k, v in pairs(tbNext) do
--	print(k, v)
--end
--local szMode = "aab"
--local szDst = "aaa"
--local pos = kmp_ex(szDst, "aab")
--print("pos: ", pos)

function random_seq(len)
	local szSeq = ""
	for i=1, len do
		local r = math.random(2)
		szSeq = szSeq .. tostring(r);
	end
	return szSeq
end

function test_kmp()
	for i=1, 5 do
		local szDst = random_seq(2)
		local szMod = random_seq(3)
		print(szDst, szMod)
		local posDst, posMod = kmp_ex(szDst, szMod)
		print("pos: ", posDst, posMod)
	end
end

--[[
121	221
pos: 	0
122	212
pos: 	0
221	111
pos: 	0
112	111
pos: 	2
112	222
pos: 	0
]]
--print(kmp_ex("12", "112"))
--test_kmp();

--[[
12	122
pos: 	-1	nil
11	222
pos: 	1	0
12	221
pos: 	1	0
11	111
pos: 	-1	nil
21	111
pos: 	1	0
]]
--print(kmp_ex("222", "12"))

function CmpKill2Mode(szKill, szMode)
	--if string.len(szKill) ~= string.len(szMode) then return -1; end
	--if szKill == szMode then
	--	return 0;
	--end
	local nPos = string.find(szKill, szMode)
	if nPos then 
		return 0, nPos + string.len(szMode);	--这里只要第二个参数
	end
	local szTemp = szKill
	local nLen = string.len(szTemp)
	while nLen > 1 do
		szTemp = string.sub(szTemp, 2, nLen)
		local nPos = string.find(szMode, szTemp)
		--print(szTemp, nPos)
		if nPos and nPos == 1 then
			return nLen-1, nPos;
		end
		nLen = string.len(szTemp)
	end
	
	if nLen == 1 then
		local szMode_1 = string.sub(szMode, 1, 1)
		--print(szKill, szMode_1)
		if szKill == szMode_1 then
			return 1, 1
		end
	end
	return -1;
end
for i = 1, 10 do
	local sz1 = random_seq(6)
	local sz2 = random_seq(5)
	local nRet, nPos = CmpKill2Mode(sz1, sz2)
	if nRet >= 0 then
		--print(sz1, sz2, nRet, nPos)
	end
end

local nRet, nPos = CmpKill2Mode("1", "112")
-- print(nRet, nPos)
--local szTest = string.sub("221", nPos, string.len("221"))
--print(szTest, string.len(szTest))

-------------------------
--这是什么用法？
function CheckLua()
	local s = "a string with \r and \n and \r\n and \n\r"
	print(10, s)
	local c = string.format("return %q", s)
	local z = assert(loadstring(c))()
	print(11, z)
	print(12, a == s)
	assert(assert(loadstring(c))() == s)
end
-- print(111, CheckLua())


local tbTest = {1, 2, 3}
--tbTest[2], tbTest[3] = tbTest[3], tbTest[2]
for k, v in ipairs(tbTest) do
	--print (k, v)
end

function AllPerm(tbTest)
	--test
	--print("AllPerm start......", #tbTest)
	for k, v in ipairs(tbTest) do
		--print(v)
	end
	
	if #tbTest == 1 then
		print(tbTest[1], ",")
		return;
	end
	
	--copy
	local tbData = {}
	for _, v in ipairs(tbTest) do
		table.insert(tbData, v)
	end
	
	local tbPerm = {}
	for k, v in ipairs(tbTest) do
		--change
		tbData[k], tbData[#tbData] = tbData[#tbData], tbData[k]
		print(tbData[#tbData], ",")
		
		local n = table.remove(tbData)
		AllPerm(tbData)
		print(".....", n)
		
		--copy back
		tbData = {}
		for _, v in ipairs(tbTest) do
			table.insert(tbData, v)
		end
	end
	
	--copy back
	--for _, v in ipairs(tbTest) do
	--	table.insert(tbData, v)
	--end
end

--AllPerm(tbTest)

--2015/01/29 string.len("")
-- print(string.len(""))

--2015/08/25 捕获
-- local pair = "name = Anna"
-- local key, value = string.match(pair, "(%a+)%s*=%s*(%a+)")
-- print(key, value)
-- local pair1 = "【xxx】 jiu是这样的e"
-- local s1, s2 = string.match(pair1, "【(.*)】%s*(.*)");
-- print(pair1, s1, s2);
-- local s3, s4 = string.find(pair1, "【%s")
-- print(s3, s4);

-- print(os.date("%X", os.time()))
-- print(os.date("%p", os.time()))
-- print(os.date("%H:%M", os.time()))

-- add a postfix 2017/12/23
local szTest = "PaperSprite'/Game/UI/Icon/Skill/GS/Frames/gs_icon0000.gs_icon0000'";
local szPath, szEnd = string.match(szTest, "PaperSprite'(.+)%.(.+)'");
print("szPath = ", szPath, szEnd)
print("new = ", string.format("PaperSprite'%s_D.%s_D'", szPath, szEnd))

-- 2015/08/26 不定长参数
function addMessageTipsEx(...)
	local massage = string.format("%s:%d", ...)
	print(massage);
end

-- addMessageTipsEx("test", 6);

-- 2015/12/23 比较时间
function compare()
	local nMax = 1000000;
	local t1 = os.clock();
	for i = 1, nMax do
		if "asdggasddg4" == "aakjpllsgc" then
		end
	end
	local t2 = os.clock()
	print(111, t2-t1);
	
	local n1 = math.random(100000);
	local n2 = math.random(100000);
	local t3 = os.clock();
	for i = 1, nMax do
		if n1 == n2 then
		end
	end
	local t4 = os.clock()
	print(222, t4-t3);
end

-- compare();

------------------------------------------------------------
-- 2016/10/10 判断有没有前16个字符相同的魔法属性串
local tbMagicString = {
	"common_probability",											-- 统一成功几率
	"back_attack_damage_add_percent",								-- 背击伤害比例加成
	"skilling_attack_damage_add_percent",							-- 破技伤害比例加成
	"back_attack_injury_add_percent",								-- 背击气绝值比例加成
	"skilling_attack_injury_add_percent",							-- 破技气绝值比例加成
	"damage_destroy_zhen",											-- 破阵
	"damage_direct_death",											-- 直接致死
	"damage_direct_death_by_npc_type",								-- 根据Npc类型直接致死
	"damage_pn_attack_add",											-- 两仪状态攻击加成	
	"damage_attack_enemy_def_add",									-- 敌人防御比例对攻击力加成(专门针对高防的敌人)
	"damage_ignore_rebound_per",									-- 伤害反弹削减比例
	"damage_cancle_knockdown",										-- 取消倒地（几率）
	"damage_beat_partner_value",									-- 打击值
	"damage_knockdown",												-- 击倒（几率+后退坐标数）
	"damage_knockback",												-- 击退（只有几率）	
	"damage_beat_move",												-- 被击位移表现
	"damage_beat_ctrl",												-- 被击控制位移表现
	"damage_add_defense_percent",									-- 对防御状态NPC增加伤害百分比
	"damage_add_breakdefense_percent",								-- 对破防状态NPC增加伤害百分比
	"damage_add_defense_point",										-- 对防御状态NPC增加伤害点数
	"damage_add_breakdefense_point",								-- 对破防状态NPC增加伤害点数
	"critical_add_defense_per10k",									-- 攻击防御目标增加暴击概率，万分比
	"critical_add_breakdefense_per10k",								-- 攻击破防目标增加暴击概率，万分比
	"critical_add_damage_defense",									-- 攻击防御目标增加暴击伤害，百分比
	"critical_add_damage_breakdefense",								-- 攻击破防目标增加暴击伤害，百分比
	"critical_damage_odds_add_percent",								-- 攻击目标暴击伤害概率百分比增加
	"damage_add_by_missle_fly_time",								-- 根据子弹飞行时间增加伤害
	"damage_yin_life",												-- 伤害减阴属性单位生命
	"damage_life",													-- 伤害减生命
	"damage_mana",													-- 伤害减内力
	"damage_stamina",												-- 伤害减体力
	"damage_life2",													-- 
	"damage_absorb_life",											-- 吸取生命
	"damage_absorb_mana",											-- 吸取内力
	"damage_absorb_stamina",										-- 吸取体力
	"damage_weapon_perdure",										-- 伤害武器持久度
	"damage_armor_perdure",											-- 伤害防具持久度
	"damage_cause_i_wound_level",									-- 致内伤等级
	"damage_cause_o_wound_level",									-- 致外伤等级
	"damage_thieve_money",											-- 偷取金钱数量
	"damage_thieve_skill",											-- 偷取状态
	"damage_thieve_item",											-- 偷取物品
	"damage_dispell_type",											-- 状态清除类型
	"damage_dispell_num",											-- 状态清除数目
	"damage_self_perdure_p",										-- 武器持久度损耗
	"damage_reserved",												-- 保留使用属性(其意义根据不同技能而定)
	"damage_add_enmity_p",											-- 仇恨度增加比例
	"damage_draw_near",												-- 把目标拉到身前
	"damage_interrupt_rate_add",									-- 提高攻击打断敌人武功概率
	"damage_retrusive_rate_add",									-- 提高攻击使敌人后仰概率
	"damage_retrusive_time",										-- 技能造成后仰时间 ，以帧为单位
	"damage_retrusive_time_limit",									-- 后仰时间下限，以帧为单位
	"damage_life_monster",											-- 针对Npc的生命伤害
	"damage_change_position",										-- 和目标换位置
	"damage_zhen",													-- 设置阵法状态
}

function fnFindPre16( tbStrings )
	local tbStrings = tbStrings or {};
	local tbHashPre16 = {};
	for _, str in paris(tbStrings) do
		-- 截取字符串前16个字符
		local strTmp = string.sub(str, 1, 16);
	end
end

--[[sum:
* 用的是字符串指针，16个字符串指针，而并不是说字符串长度为16。
* 代码：char* ppString[nStringCount] = {0};
]]

------------------------------------------------------------
-- 2017-09-02 13:44:51
-- stackoverflow

a = "stackoverflow.com/questions/ask"

-- print(string.match(a,"(.*/)"))   -- stackoverflow.com/questions/
-- print(string.match(a,"((.*/).*)")) -- stackoverflow.com/questions/


------------------------------------------------------------
 -- 2017-09-13 12:12:25
 -- stackoverflow match
 local function splitString(text)
    pattern = "<(%a+)>%s*([^>]+)"
    i,j = string.match(text, pattern)
    return i,j
end

-- print(splitString("<c> block"))           -- c  block
-- print(splitString("<category>material"))  -- category   material
-- print(splitString("decorative"))          -- nil    nil

------------------------------------------------------------
-- string array
local szString = "abcdefghijklmnopqrstuvwxyz";
print(szString[2])
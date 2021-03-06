--Mad Profiler
function c511001388.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83965310,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c511001388.spcon)
	e2:SetOperation(c511001388.spop)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511001388,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c511001388.cost)
	e3:SetTarget(c511001388.tg)
	e3:SetOperation(c511001388.op)
	c:RegisterEffect(e3)
end
function c511001388.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and rg:GetCount()>2 and aux.SelectUnselectGroup(rg,e,tp,3,3,aux.ChkfMMZ(1),0)
end
function c511001388.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp)
	local sg=aux.SelectUnselectGroup(rg,e,tp,3,3,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE)
	Duel.Release(sg,REASON_COST)
end
function c511001388.cfilter(c,tp)
	local tpe=0
	if c:IsType(TYPE_MONSTER) then tpe=tpe|TYPE_MONSTER end
	if c:IsType(TYPE_SPELL) then tpe=tpe|TYPE_SPELL end
	if c:IsType(TYPE_TRAP) then tpe=tpe|TYPE_TRAP end
	return c:IsAbleToGraveAsCost() and Duel.IsExistingTarget(c511001388.banfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tpe)
end
function c511001388.banfilter(c,tpe)
	return c:IsType(tpe) and c:IsAbleToRemove() and (c:IsFaceup() or tpe&TYPE_MONSTER>0)
end
function c511001388.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511001388.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c511001388.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	local tpe=0
	if tc:IsType(TYPE_MONSTER) then tpe=tpe|TYPE_MONSTER end
	if tc:IsType(TYPE_SPELL) then tpe=tpe|TYPE_SPELL end
	if tc:IsType(TYPE_TRAP) then tpe=tpe|TYPE_TRAP end
	e:SetLabel(tpe)
end
function c511001388.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c511001388.banfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c511001388.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

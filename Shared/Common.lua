local function GetCore()
  if (ZSX ~= nil) then return ZSX; else return nil; end
end

exports(
  'GetCore',
  GetCore
)

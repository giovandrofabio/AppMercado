object DmUsuario: TDmUsuario
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 287
  Width = 379
  object TabUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 64
    Top = 32
  end
  object conn: TFDConnection
    AfterConnect = connAfterConnect
    BeforeConnect = connBeforeConnect
    Left = 208
    Top = 152
  end
  object QryGeral: TFDQuery
    Connection = conn
    Left = 264
    Top = 120
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 256
    Top = 208
  end
  object QryUsuario: TFDQuery
    Connection = conn
    Left = 120
    Top = 152
  end
end

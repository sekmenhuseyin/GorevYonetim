using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;
using System.Reflection;

namespace GorevYonetim
{
    public class CustomMappingSource : MappingSource
    {
        private string Shema = string.Empty;
        private AttributeMappingSource mapping = new AttributeMappingSource();

        protected override MetaModel CreateModel(Type dataContextType)
        {
            return new CustomMetaModel(mapping.GetModel(dataContextType), Shema);
        }

        public CustomMappingSource(string shema)
        {
            Shema = shema;
        }
    }

    public class CustomMetaModel : MetaModel
    {
        private string Shema = string.Empty;
        private static CustomMappingSource mapping;

        private MetaModel model;

        public CustomMetaModel(MetaModel model, string shema)
        {
            this.model = model;
            Shema = shema;
            mapping = new CustomMappingSource(shema);
        }

        public override Type ContextType
        {
            get { return model.ContextType; }
        }

        public override MappingSource MappingSource
        {
            get { return mapping; }
        }

        public override string DatabaseName
        {
            get { return model.DatabaseName; }
        }

        public override Type ProviderType
        {
            get { return model.ProviderType; }
        }

        public override MetaTable GetTable(Type rowType)
        {
            return new CustomMetaTable(model.GetTable(rowType), model, Shema);
        }

        public override IEnumerable<MetaTable> GetTables()
        {
            foreach (var table in model.GetTables())
                yield return new CustomMetaTable(table, model, Shema);
        }

        public override MetaFunction GetFunction(System.Reflection.MethodInfo method)
        {
            return model.GetFunction(method);
        }

        public override IEnumerable<MetaFunction> GetFunctions()
        {
            return model.GetFunctions();
        }

        public override MetaType GetMetaType(Type type)
        {
            return model.GetMetaType(type);
        }
    }

    public class CustomMetaTable : MetaTable
    {
        private string Shema = string.Empty;
        private MetaTable table;
        private MetaModel model;

        public CustomMetaTable(MetaTable table, MetaModel model, string shema)
        {
            this.table = table;
            this.model = model;
            Shema = shema;

            var tableNameField = table.GetType().FindMembers(MemberTypes.Field, BindingFlags.NonPublic | BindingFlags.Instance, (member, criteria) => member.Name == "tableName", null).OfType<FieldInfo>().FirstOrDefault();
            if (tableNameField != null)
                tableNameField.SetValue(table, TableName);
        }

        public override System.Reflection.MethodInfo DeleteMethod
        {
            get { return table.DeleteMethod; }
        }

        public override System.Reflection.MethodInfo InsertMethod
        {
            get { return table.InsertMethod; }
        }

        public override System.Reflection.MethodInfo UpdateMethod
        {
            get { return table.UpdateMethod; }
        }

        public override MetaModel Model
        {
            get { return model; }
        }

        public override string TableName
        {
            get
            {
                if (Shema != string.Empty)
                {
                    string[] Sdizi = Shema.Split(',');
                    if (Sdizi.Length == 2)
                    {
                        if (table.TableName.Split('.')[0].Trim() == Sdizi[0].Trim())
                            return Sdizi[1].Trim() + "." + table.TableName.Split('.')[1].Trim();
                        else if (Sdizi[0].Trim() == "*")
                            return Sdizi[1].Trim() + "." + table.TableName.Split('.')[1].Trim();
                        else
                            return table.TableName;
                    }
                    else
                    {
                        return table.TableName;
                    }
                    //return Shema + "." + table.TableName.Split('.')[1];
                }
                else
                {
                    //Shema = table.TableName.Split('.')[0];
                    return table.TableName;
                }
            }
        }

        public override MetaType RowType
        {
            get { return table.RowType; }
        }
    }
}

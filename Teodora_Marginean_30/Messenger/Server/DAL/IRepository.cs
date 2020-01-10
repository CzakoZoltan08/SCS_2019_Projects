using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

namespace Server.DAL
{
    public interface IRepository<T> where T:class
    {
        IEnumerable<T> Get(
            Expression<Func<T, bool>> filter = null,
            Func<IQueryable<T>, IOrderedQueryable<T>> orderBy = null,
            string includeProperties = ""
        );
        T GetById(object id);
        IEnumerable<T> GetWithRawSql(string query, params object[] parameters);
        void Insert(T entity);
        void Update(T entityToUpdate);
        void Delete(T entityToDelete);
        void DeleteById(object id);
    }
}

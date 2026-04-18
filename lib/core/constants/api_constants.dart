class ApiConstants {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dev.ansormarket.uz',
  );
  static const cdnBaseUrl = String.fromEnvironment(
    'CDN_BASE_URL',
    defaultValue: 'https://cdn.ansormarket.uz',
  );

  // Auth
  static const register = '/api/auth/register';
  static const login = '/api/auth/login';
  static const refresh = '/api/auth/refresh';
  static const logout = '/api/auth/logout';

  // Products
  static const productsGetList = '/api/products/getlist';
  static const products = '/api/products';

  // Categories
  static const categoriesGetList = '/api/categories/getlist';
  static const categoriesGetTree = '/api/categories/gettree';
  static const categories = '/api/categories';

  // Cart
  static const cart = '/api/cart';
  static const cartGetCart = '/api/cart/getcart';
  static const cartAddItem = '/api/cart/additem';
  static const cartClear = '/api/cart/clear';

  // Customer
  static const customerGetProfile = '/api/customer/getprofile';
  static const customerUpdateProfile = '/api/customer/updateprofile';
  static const customerChangePassword = '/api/customer/changepassword';

  // Branches
  static const branchesGetList = '/api/branches/getlist';
  static const branches = '/api/branches';
  static const branchesInRange = '/api/branches/in-range';
}

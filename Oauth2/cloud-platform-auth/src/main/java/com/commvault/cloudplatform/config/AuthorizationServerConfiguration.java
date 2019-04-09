package com.commvault.cloudplatform.config;

import com.commvault.cloudplatform.security.CVTokenEnhancer;
import com.commvault.cloudplatform.security.CVTokenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.oauth2.config.annotation.configurers.ClientDetailsServiceConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configuration.AuthorizationServerConfigurerAdapter;
import org.springframework.security.oauth2.config.annotation.web.configuration.EnableAuthorizationServer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerEndpointsConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerSecurityConfigurer;
import org.springframework.security.oauth2.provider.token.store.InMemoryTokenStore;

@Configuration
@EnableAuthorizationServer
public class AuthorizationServerConfiguration extends AuthorizationServerConfigurerAdapter {

    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private UserDetailsService userDetailsService;

    private static int TOKEN_EXPIRATION_TIME = 1800;

    private static final String RESOURCE_ID = "commvault";
    /**
     * 配置客户端详情
     * @param clients
     * @throws Exception
     * 用来配置客户端详情服务（ClientDetailsService），客户端详情信息在这里进行初始化，能够把客户端详情信息写死在这里或者是通过数据库来存储调取详情信息。
     * clientId：（必须的）用来标识客户的Id。
     * secret：（需要值得信任的客户端）客户端安全码，如果有的话。
     * redirectUris 返回地址,可以理解成登录后的返回地址，可以多个。应用场景有:客户端swagger调用服务端的登录页面,登录成功，返回客户端swagger页面
     * authorizedGrantTypes：此客户端可以使用的权限（基于Spring Security authorities）
     * authorization_code：授权码类型、implicit：隐式授权类型、password：资源所有者（即用户）密码类型、
     * client_credentials：客户端凭据（客户端ID以及Key）类型、refresh_token：通过以上授权获得的刷新令牌来获取新的令牌。
     * scope：用来限制客户端的访问范围，如果为空（默认）的话，那么客户端拥有全部的访问范围。
     * accessTokenValiditySeconds token有效时长
     * refreshTokenValiditySeconds refresh_token有效时长
     */
    @Override
    public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
        clients.inMemory()
                .withClient("cv_client")
                .resourceIds(RESOURCE_ID)
                .secret("cv_secret")
                .authorizedGrantTypes("password", "refresh_token")
                .scopes("all")
                .accessTokenValiditySeconds(TOKEN_EXPIRATION_TIME)
                .refreshTokenValiditySeconds(0);//refreshToken永不过期
    }

    /**
     * 配置授权服务器端点，如令牌存储，令牌自定义，用户批准和授权类型，不包括端点安全配置
     * 用来配置授权（authorization）以及令牌（token）的访问端点和令牌服务(token services)。
     *     访问地址：/oauth/token
     *     属性列表:
     *     authenticationManager：认证管理器，当你选择了资源所有者密码（password）授权类型的时候，需要设置为这个属性注入一个 AuthenticationManager 对象。
     *
     * @param endpoints
     * @throws Exception
     *AuthorizationServerEndpointsConfigurer 配置对象有一个 pathMapping() 方法用来配置端点的 URL，它有两个参数：

    参数一：端点 URL 默认链接
    参数二：替代的 URL 链接


    下面是一些默认的端点 URL：

    /oauth/authorize：授权端点
    /oauth/token：令牌端点
    /oauth/confirm_access：用户确认授权提交端点
    /oauth/error：授权服务错误信息端点
    /oauth/check_token：用于资源服务访问的令牌解析端点
    /oauth/token_key：提供公有密匙的端点，如果你使用JWT令牌的话


    授权端点的 URL 应该被 Spring Security 保护起来只供授权用户访问
     */
    @Override
    public void configure(AuthorizationServerEndpointsConfigurer endpoints) throws Exception {
        endpoints
                //将token存储在内存中
                .tokenStore(new InMemoryTokenStore())
                .authenticationManager(authenticationManager)
                // 必须要注入 userDetailsService，否则根据refresh_token无法加载用户信息，因为我们只传递了client的信息。
                .userDetailsService(userDetailsService)
                // 允许 GET、POST 请求获取 token，即访问端点：oauth/token
                .allowedTokenEndpointRequestMethods(HttpMethod.GET, HttpMethod.POST)
                .tokenEnhancer(new CVTokenEnhancer());

        //endpoints.reuseRefreshTokens(true);
        CVTokenService cvTokenService = new CVTokenService(endpoints.getTokenStore(), true, endpoints.getClientDetailsService(), endpoints.getTokenEnhancer());
        //自定义token
        endpoints.tokenServices(cvTokenService);
    }

    /**
     * 配置授权服务器端点的安全
     * @param security
     * @throws Exception
     */
    @Override
    public void configure(AuthorizationServerSecurityConfigurer security) throws Exception {
        //让/oauth/token支持client_id以及client_secret作登录认证
        security.allowFormAuthenticationForClients();
        //允许check_token访问
        //security.checkTokenAccess("permitAll()");
        security.checkTokenAccess("isAuthenticated()");
    }

}

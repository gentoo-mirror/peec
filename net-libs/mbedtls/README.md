
mbedtls package used for testing applications that depend on this library.

see gentoo bugzilla [bug #805011](https://bugs.gentoo.org/805011#c10) for details.

required package.mask modification:

```
<=net-libs/mbedtls-3.1.0
>=net-libs/mbedtls-3.6.2-r10
```

[1] tested with version from [overlay](https://codeberg.org/subDIMENSION/gentoo-overlay/src/branch/master/net-voip/umurmur)


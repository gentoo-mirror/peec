# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="tools and schema data for Devicetree schema validation"
HOMEPAGE="
	https://github.com/devicetree-org/dt-schema
	https://pypi.org/project/dtschema
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc"

RDEPEND="
	sys-apps/dtc[python]
	>dev-python/ruamel-yaml-0.15.69[${PYTHON_USEDEP}]
	<dev-python/jsonschema-4.18[${PYTHON_USEDEP}]
	dev-python/rfc3987[${PYTHON_USEDEP}]
"

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}

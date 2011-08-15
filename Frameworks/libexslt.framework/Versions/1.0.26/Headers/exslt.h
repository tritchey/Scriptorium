
#ifndef __EXSLT_H__
#define __EXSLT_H__

#include <libxml/tree.h>
#include "exsltconfig.h"

#ifdef __cplusplus
extern "C" {
#endif

LIBEXSLT_PUBLIC extern const char *exsltLibraryVersion;
LIBEXSLT_PUBLIC extern const int exsltLibexsltVersion;
LIBEXSLT_PUBLIC extern const int exsltLibxsltVersion;
LIBEXSLT_PUBLIC extern const int exsltLibxmlVersion;

/**
 * EXSLT_COMMON_NAMESPACE:
 *
 * Namespace for EXSLT common functions
 */
#define EXSLT_COMMON_NAMESPACE ((const xmlChar *) "http://exslt.org/common")
/**
 * EXSLT_MATH_NAMESPACE:
 *
 * Namespace for EXSLT math functions
 */
#define EXSLT_MATH_NAMESPACE ((const xmlChar *) "http://exslt.org/math")
/**
 * EXSLT_SETS_NAMESPACE:
 *
 * Namespace for EXSLT set functions
 */
#define EXSLT_SETS_NAMESPACE ((const xmlChar *) "http://exslt.org/sets")
/**
 * EXSLT_FUNCTIONS_NAMESPACE:
 *
 * Namespace for EXSLT functions extension functions
 */
#define EXSLT_FUNCTIONS_NAMESPACE ((const xmlChar *) "http://exslt.org/functions")
/**
 * EXSLT_STRINGS_NAMESPACE:
 *
 * Namespace for EXSLT strings functions
 */
#define EXSLT_STRINGS_NAMESPACE ((const xmlChar *) "http://exslt.org/strings")
/**
 * EXSLT_DATE_NAMESPACE:
 *
 * Namespace for EXSLT date functions
 */
#define EXSLT_DATE_NAMESPACE ((const xmlChar *) "http://exslt.org/dates-and-times")
/**
 * EXSLT_DYNAMIC_NAMESPACE:
 *
 * Namespace for EXSLT dynamic functions
 */
#define EXSLT_DYNAMIC_NAMESPACE ((const xmlChar *) "http://exslt.org/dynamic")

/**
 * SAXON_NAMESPACE:
 *
 * Namespace for SAXON extensions functions
 */
#define SAXON_NAMESPACE ((const xmlChar *) "http://icl.com/saxon")

void LIBEXSLT_PUBLIC exsltCommonRegister (void);
void LIBEXSLT_PUBLIC exsltMathRegister (void);
void LIBEXSLT_PUBLIC exsltSetsRegister (void);
void LIBEXSLT_PUBLIC exsltFuncRegister (void);
void LIBEXSLT_PUBLIC exsltStrRegister (void);
void LIBEXSLT_PUBLIC exsltDateRegister (void);
void LIBEXSLT_PUBLIC exsltSaxonRegister (void);
void LIBEXSLT_PUBLIC exsltDynRegister(void);

void LIBEXSLT_PUBLIC exsltRegisterAll (void);

#ifdef __cplusplus
}
#endif
#endif /* __EXSLT_H__ */


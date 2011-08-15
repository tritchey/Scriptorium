//
//  XMLNode.m
//  xmltest
//
//  Created by Timothy Ritchey on Mon Feb 17 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "XMLNode.h"
#import "XMLDocument.h"
#import "XMLAttribute.h"
#import "XMLDTD.h"
#import "XMLElement.h"
#import "XMLText.h"
#import "XMLCDATA.h"
#import "XMLComment.h"
#import "XMLEntity.h"

@implementation XMLNode

+ (XMLNode*)xmlNodeWithNode:(xmlNodePtr)aNode
{
    xmlNodePtr node = aNode;
    while(node) {
        switch (node->type) {
            case XML_ELEMENT_NODE:
                node->_private = [XMLElement class];
                [self xmlNodeWithNode:(xmlNodePtr)node->properties];
                break;
            case XML_TEXT_NODE:
                node->_private = [XMLText class];
                break;
            case XML_CDATA_SECTION_NODE:
                node->_private = [XMLCDATA class];
                break;
            case XML_COMMENT_NODE:
                node->_private = [XMLComment class];
                break;
            case XML_ATTRIBUTE_NODE:
                node->_private = [XMLAttribute class];
                break;
            case XML_DOCUMENT_NODE:
                node->_private = [XMLDocument class];
                [self xmlNodeWithNode:(xmlNodePtr)((xmlDocPtr)node)->intSubset];
                [self xmlNodeWithNode:(xmlNodePtr)((xmlDocPtr)node)->extSubset];
                break;
            case XML_DTD_NODE:
                node->_private = [XMLDTD class];
                break;
            case XML_ENTITY_REF_NODE:
                node->_private = [XMLEntity class];
                break;
            case XML_ENTITY_NODE:
            case XML_PI_NODE:
            case XML_DOCUMENT_TYPE_NODE:
            case XML_DOCUMENT_FRAG_NODE:
            case XML_NOTATION_NODE:
            case XML_HTML_DOCUMENT_NODE:
            case XML_ELEMENT_DECL:
            case XML_ATTRIBUTE_DECL:
            case XML_ENTITY_DECL:
            case XML_NAMESPACE_DECL:
            case XML_XINCLUDE_START:
            case XML_XINCLUDE_END:
            default:
                node->_private = [XMLNode class];
                break;
        }
        [self xmlNodeWithNode:node->children];
        node = node->next;
    }

    return (XMLNode*)aNode;
}

- (NSString*)description
{
    xmlBufferPtr buffer = xmlBufferCreate();
    xmlNodeDump(buffer,
                (xmlDocPtr)doc,
                (xmlNodePtr)self,
                0, 0);

    NSString *string = [NSString stringWithCString:buffer->content];

    xmlBufferFree(buffer);
    return string;
}

- (id)copyWithZone:(NSZone*)zone
{
    return [XMLNode xmlNodeWithNode:xmlCopyNode((xmlNodePtr)self,1)];
}

- (xmlElementType)type
{
    return type;
}

- (void)setType:(xmlElementType)aType
{
    type = aType;
    // can I change the isa?
}

- (NSString*)name
{
    if(name)
        return [NSString stringWithCString:name];
    return nil;
}

- (void)setName:(NSString*)aString
{
    xmlNodeSetName((xmlNodePtr)self, [aString cString]);
}

- (XMLNode*)children
{
    return children;
}

- (XMLNode*)last
{
    return last;
}

- (XMLNode*)parent
{
    return parent;
}

- (XMLNode*)next
{
    return next;
}

- (XMLNode*)prev
{
    return prev;
}

- (XMLDocument*)doc
{
    return doc;
}

- (void)addChild:(XMLNode*)child
{
    xmlAddChild((xmlNodePtr)self, (xmlNodePtr)child);
}

- (void)addSibling:(XMLNode*)sibling
{
    xmlAddSibling((xmlNodePtr)self, (xmlNodePtr)sibling);
}

- (void)addNextSibling:(XMLNode*)sibling
{
    xmlAddNextSibling((xmlNodePtr)self, (xmlNodePtr)sibling);
}

- (void)addPrevSibling:(XMLNode*)sibling
{
    xmlAddPrevSibling((xmlNodePtr)self, (xmlNodePtr)sibling);
}


- (NSArray*)potentialChildren
{
    int count = 0, i = 0;
    const xmlChar * list[256];
    NSMutableArray *array = [NSMutableArray array];

    xmlElement * element_desc = NULL ;

    // sanity checks
    if (type != XML_ELEMENT_NODE) return nil ;
    if (parent == NULL) return nil ;

    element_desc = xmlGetDtdElementDesc((xmlDtdPtr)[[parent doc] intSubset],
                                        name);
    if ((element_desc == NULL) && ([[parent doc] extSubset] != NULL))
        element_desc = xmlGetDtdElementDesc((xmlDtdPtr)[[parent doc] extSubset],
                                            name) ;
    if (element_desc == NULL) return (nil) ;

    count = xmlValidGetPotentialChildren (element_desc->content,
                                          (const xmlChar**)list,
                                          &count,
                                          256) ;
    for(i = 0; i < count; ++i) {
        [array addObject:[NSString stringWithCString:list[i]]];
    }

    return array;
}

- (void)prune
{
    // remove this node from the tree.
    // ?? should I free it?
    xmlUnlinkNode((xmlNodePtr)self);
}

- (NSString*)content
{
    return nil;
}

- (void)setContent:(NSString*)aString
{
    // do nothing
}

- (void)replaceContentInRange:(NSRange)aRange withString:(NSString*)aString
{
    // do nothing
}

- (XMLAttribute*)properties
{
    return nil;
}

- (void)dealloc
{
    NSLog(@"deallocating a node!");
    // maybe I should free this node...
    [super dealloc];
}

@end

int xmlValidGetValidElementsChildren (xmlNode *a_node,
                                      const xmlChar **a_list,
                                      int a_max)
{
    xmlElement * element_desc = NULL ;
    int nb_valid_elements = 0 ;

    /*some sanity checks...*/
    if (a_node == NULL) return -2 ;
    if (a_list == NULL) return -2 ;
    if (a_list == NULL)  return -2 ;
    if (a_max == 0) return -2 ;
    if (a_node->type != XML_ELEMENT_NODE) return -2 ;
    if (a_node->parent == NULL) return -2 ;

    if (a_node->children) {
        /*the node is the root node
        *and it has children. We can it valid children
        *with the function
        */
        return xmlValidGetValidElements (a_node->last, NULL,
                                         a_list, a_max) ;

    } else {
        int nb_elements = 0, i = 0 ;
        const xmlChar * elements[256] ;
        xmlNode * test_node = NULL ;
        xmlValidCtxt vctxt ;

        memset(&vctxt, 0, sizeof (xmlValidCtxt));

        element_desc = xmlGetDtdElementDesc(a_node->parent->doc->intSubset,
                                            a_node->name);
        if ((element_desc == NULL) && (a_node->parent->doc->extSubset != NULL))
            element_desc = xmlGetDtdElementDesc(a_node->parent->doc->extSubset,
                                                a_node->name) ;
        if (element_desc == NULL) return (-1) ;

        /*
         *Create a dummy child element
         */
        test_node =
            xmlNewChild (a_node, NULL, "<!dummy?>", NULL) ;

        /*
         *Insert each potential child node and check if the current node is still valid.
         */
        nb_elements =
            xmlValidGetPotentialChildren (element_desc->content,
                                          elements, &nb_elements, 256) ;

        for (i = 0 ; i < nb_elements ; i++) {
            test_node->name = elements[i] ;
            if (xmlStrEqual(test_node->name, "#PCDATA"))
                test_node->type = XML_TEXT_NODE ;
            else
                test_node->type = XML_ELEMENT_NODE ;

            if (xmlValidateOneElement (&vctxt, a_node->parent->doc, a_node)) {
                int j ;
                for (j = 0 ; j < nb_valid_elements ; j++)
                    if (xmlStrEqual (elements[i], a_list[j])) break ;
                a_list[nb_valid_elements++] = elements[i] ;

                if (nb_valid_elements >= a_max) break ;
            }
        }

        /*
         *Restore the tree structure
         */
        xmlUnlinkNode (test_node) ;

        return nb_valid_elements ;
    }
}

% [X] accetta documentclass qualsiasi e usala
% [X] passa opzioni custom cls scelta
% [X] macro facile per condizionale class-dependent
% [ ] accetta metadati in formato standard
% [ ] parsa metadati e dalli a classe scelta

\RequirePackage { expl3 }% TODO: [2017/07/19]
\RequirePackage { l3keys2e }
\RequirePackage { xparse }

%\NeedsTeXFormat{LaTeX2e}[1995/12/01]

\ProvidesExplClass{stysyphus}
{2023/05/11}
{0.1.0}
{}

\ExplSyntaxOn

%\tl_new:N \l_stysyphus_target_tl

\keys_define:nn { stysyphus }
{
    target .tl_set:N  = \l_stysyphus_target_tl,
    % target .value_required:n = true,
    % target .initial:n = { article },
    option .tl_set:N  = \l_stysyphus_option_tl,
    %option .initial:n = {},
    meta .tl_set:N  = \l_stysyphus_meta_tl,
}

\ProcessKeysOptions { stysyphus }

\cs_generate_variant:Nn \prop_set_from_keyval:Nn { NV }

\tl_new:N \l_stysyphus_options_prop
\prop_set_from_keyval:NV \l_stysyphus_options_prop \l_stysyphus_option_tl

\tl_new:N \l_stysyphus_meta_prop
\prop_set_from_keyval:NV \l_stysyphus_meta_prop \l_stysyphus_meta_tl


\prop_get:NVN \l_stysyphus_options_prop \l_stysyphus_target_tl \l_tmpa_tl

%\PassOptionsToClass {
% version = last,
%} { scrreprt }

\edef\lol{
    \noexpand\LoadClass [ \tl_use:N \l_tmpa_tl ]
    { \tl_use:N \l_stysyphus_target_tl }
}
\lol

%\AtBeginDocument{
%   Hello, \tl_use:N \l_stysyphus_target_tl!
%   \par
%   Hello, \tl_use:N \l_stysyphus_option_tl!
%}

\cs_generate_variant:Nn \tl_if_eq:nnTF { nVTF }
\NewDocumentEnvironment { stysyphus } { m +b }
{ \tl_if_eq:nVTF { #1 } \l_stysyphus_target_tl { #2 } {} } {}

\NewDocumentCommand \inlineStysyphus { m } {
    \str_case:Nn \l_stysyphus_target_tl { #1 }
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\prop_get:NnN \l_stysyphus_meta_prop { title } \l_tmpa_tl
\exp_args:Ne \title { \tl_use:N \l_tmpa_tl }

\prop_get:NnN \l_stysyphus_meta_prop { authors } \l_tmpa_tl
\clist_set:NV \l_tmpa_clist \l_tmpa_tl
% \clist_show:N \l_tmpa_clist

% elsarticle
\tl_if_eq:nVTF { elsarticle } \l_stysyphus_target_tl {
    \clist_map_inline:Nn \l_tmpa_clist {
        \prop_set_from_keyval:Nn \l_tmpb_prop { #1 }
        \prop_get:NnN \l_tmpb_prop { fullname } \l_tmpb_tl
        \exp_args:Ne \author { \tl_use:N \l_tmpb_tl }
    } } {}

% article
\tl_if_eq:nVTF { article } \l_stysyphus_target_tl {
    \seq_clear:N \l_tmpa_seq
    \clist_map_inline:Nn \l_tmpa_clist {
        \prop_set_from_keyval:Nn \l_tmpb_prop { #1 }
        \prop_get:NnN \l_tmpb_prop { fullname } \l_tmpb_tl
        \seq_put_right:NV \l_tmpa_seq \l_tmpb_tl
        }
    \exp_args:No \author { \seq_use:Nnnn \l_tmpa_seq { \and } { \and } { \and } }
} {}

% lipics-v2021
\tl_if_eq:nVTF { lipics-v2021 } \l_stysyphus_target_tl {
    % \tl_clear:N \l_tmpa_tl
    % \clist_map_inline:Nn \l_tmpa_clist {
    %     \prop_set_from_keyval:Nn \l_tmpb_prop { #1 }
    %     \prop_get:NnN \l_tmpb_prop { fullname } \l_tmpb_tl
    %     \exp_args:Ne \author { \tl_use:N \l_tmpb_tl }
} {}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ExplSyntaxOff
